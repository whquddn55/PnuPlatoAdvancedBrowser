import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pnu_plato_advanced_browser/data/notification.dart' as noti;

abstract class BackgroundLoginController {
  static String moodleSessionKey = '';

  static Future<Map<String, dynamic>> login({required final bool autologin, String? username, String? password}) async {
    assert(autologin == false ? username != null && password != null : true);
    final Map<String, dynamic> res = <String, dynamic>{};
    final preference = await SharedPreferences.getInstance();
    if (autologin == true) {
      username = preference.getString('username');
      password = preference.getString('password');
    }

    if (username == null || password == null) {
      return {"loginStatus": false, "debugMsg": "username, password가 null임", "loginMsg": "login failed with UnknownError"};
    }

    String body = 'username=$username&password=${Uri.encodeQueryComponent(password)}';
    dio.Response response;
    try {
      response = await dio.Dio().post(CommonUrl.loginUrl,
          data: body,
          options: dio.Options(followRedirects: false, contentType: 'application/x-www-form-urlencoded', headers: {
            'Host': 'plato.pusan.ac.kr',
            'Connection': 'close',
            'Content-Length': body.length.toString(),
            'Cache-Control': 'max-age=0',
            'sec-ch-ua': 'Chromium;v="88", "Google Chrome";v="88", ";Not A Brand";v="99"',
            'sec-ch-ua-mobile': '?0',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36',
            'Origin': 'https://plato.pusan.ac.kr',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
            'Referer': 'https://plato.pusan.ac.kr/',
            'Accept-Encoding': 'gzip, deflate',
            'Accept-Language': 'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7',
          }));

      /* always return 303 */
      res["debugMsg"] = 'does not return 303';
      res["loginMsg"] = 'login failed with UnknownError';
      /* TODO: popup error report */
      res["loginStatus"] = false;
      return res;
    } on dio.DioError catch (e, _) {
      /* successfully login */
      if (e.response!.statusCode == 303) {
        response = e.response!;
      }
      /* unknownError */
      else {
        res["debugMsg"] = e.toString();
        res["loginMsg"] = 'login failed with UnknownError';
        /* TODO: popup error report */
        res["loginStatus"] = false;
        return res;
      }
    }
    /* unknownError */
    catch (e) {
      res["debugMsg"] = e.toString();
      res["loginMsg"] = 'login failed with UnknownError';
      /* TODO: popup error report */
      res["loginStatus"] = false;
      return res;
    }

    /* wrong id/pw */
    if (response.headers.map['location']![0] == CommonUrl.loginErrorUrl) {
      res["debugMsg"] = 'login failed with wrong ID/PW';
      res["loginMsg"] = '잘못된 ID 또는 PW입니다. 다시 확인해주세요.';
      res["loginStatus"] = false;
      return res;
    }

    /* successfully login */
    res["moodleSessionKey"] = response.headers.map['set-cookie']![1];
    res["debugMsg"] = 'login success';
    res["loginMsg"] = '로그인 성공!';

    _updateSyncTime();
    res.addAll(await _getInformation(res["moodleSessionKey"]));

    await preference.setString('username', username);
    await preference.setString('password', password);

    CookieManager cookieManager = CookieManager.instance();
    await cookieManager.deleteAllCookies();
    await cookieManager.setCookie(
      url: Uri.parse('https://plato.pusan.ac.kr'),
      name: 'MoodleSession',
      value: res["moodleSessionKey"].split('=')[1],
      domain: 'plato.pusan.ac.kr',
      path: '/',
    );
    res["loginStatus"] = true;

    print("[DEBUG] Sync With Plato : ${moodleSessionKey}");
    moodleSessionKey = res["moodleSessionKey"];
    return res;
  }

  static Future<bool> logout() async {
    String? sessionKey = await _getSessionKey(moodleSessionKey);
    if (sessionKey == null) {
      return false;
    }
    await dio.Dio().get(CommonUrl.logoutUrl + sessionKey);

    final preference = await SharedPreferences.getInstance();
    preference.remove("username");
    preference.remove("password");

    return true;
  }

  static Future<bool> getNotifications() async {
    var options = dio.Options(headers: {'Cookie': moodleSessionKey});
    var response = await request(CommonUrl.notificationUrl, options: options, isFront: false);

    if (response == null) {
      /* TODO: 에러 */

      return false;
    }

    Document document = parse(response.data);
    int i = 0;
    /* TODO: 파일 추가해야 됨 */
    const typeNames = {'ubboard': '공지사항', 'assign': '과제', 'vod': '동영상', 'quiz': '퀴즈'};
    for (var element in document.getElementsByClassName("well wellnopadding")[0].children) {
      if (element.localName == 'a') {
        String url = element.attributes['href']!;
        String title = element.getElementsByClassName('media-heading')[0].text.split(' ')[0];
        String timeago = element.getElementsByClassName('timeago')[0].innerHtml;
        String type = typeNames[url.split('/')[4]]!;
        String body = await _getBody(url, type);
        var notification = noti.Notification(id: ++i, title: '$title($timeago)', body: '[$type]$body', url: url);
        print('$url, $title, $timeago, $type');
        await notification.notify();
      }
    }

    return true;
  }

  static Future<String> _getBody(String url, String type) async {
    var options = dio.Options(headers: {'Cookie': moodleSessionKey});
    var response = await request(url, options: options, isFront: false);
    if (response == null) {
      return 'Undefined1';
    }
    Document document = parse(response.data);
    if (type == '공지사항') {
      return document.getElementsByTagName('h3')[0].text;
    } else if (type == '과제' || type == '동영상' || type == '퀴즈') {
      return document.getElementsByClassName('breadcrumb')[0].children.last.children[0].text;
    }
    /* TODO: 에러 */

    return 'Undefined2';
  }

  static Future<String?> _getSessionKey(final String moodleSessionKey) async {
    var options = dio.Options(headers: {'Cookie': moodleSessionKey});

    var response = await request(CommonUrl.platoCalendarUrl, options: options);

    if (response == null) {
      /* TODO: 에러 */

      return null;
    }

    try {
      String data = response.data.toString();
      int sessionkeyIndex = data.indexOf('sesskey');
      String? sessionKey = data.substring(sessionkeyIndex + 10, data.indexOf(',', sessionkeyIndex) - 1);
      return sessionKey;
    } catch (e) {
      return null;
    }
  }

  static void _updateSyncTime() async {
    final preference = await SharedPreferences.getInstance();
    var now = DateTime.now();
    preference.setString("lastSyncTime", DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString());
  }

  static Future<Map<String, dynamic>> _getInformation(final String moddleSessionKey) async {
    var options = dio.Options(headers: {'Cookie': moddleSessionKey});
    var response = await request(CommonUrl.platoUserInformationUrl, options: options);

    if (response == null) {
      /* TODO: 에러 */

      return {};
    }
    Document document = parse(response.data);

    final res = <String, dynamic>{};
    res["studentId"] = int.parse(document.getElementById('fitem_id_idnumber')!.children[1].text.trim());
    res["department"] = document.getElementById('fitem_id_department')!.children[1].text.trim();
    res["name"] = document.getElementById('id_firstname')!.attributes['value']!.trim();
    res["imgUrl"] = document.getElementsByClassName('userpicture')[0].attributes['src']!;

    return res;
  }
}
