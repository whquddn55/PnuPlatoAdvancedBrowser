import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/login_information.dart';

abstract class BackgroundLoginController {
  static LoginInformation loginInformation = LoginInformation();

  static Future<bool> _checkLogin() async {
    final LoginInformation? loginInformation = StorageController.loadLoginInformation();
    if (loginInformation == null) return false;

    String body = '[{"index":0,"methodname":"core_fetch_notifications","args":{"contextid":2}}]';
    final dio.Options options = dio.Options(
      contentType: 'application/json',
      headers: {"X-Requested-With": "XMLHttpRequest"},
    );
    options.headers!["Cookie"] = loginInformation.moodleSessionKey;

    try {
      var response =
          await dio.Dio().post("https://plato.pusan.ac.kr/lib/ajax/service.php?info=core_fetch_notifications", data: body, options: options);

      printLog("checkLogin on back : ${response.data != null && response.data[0]["error"] == false}");
      return response.data != null && response.data[0]["error"] == false;
    } on dio.DioError catch (e, stacktrace) {
      if (e.type != dio.DioErrorType.other) {
        await ExceptionController.onExpcetion(stacktrace.toString(), false);
      }
      return false;
    }
  }

  static Future<void> login({required final bool autologin, String? username, String? password}) async {
    assert(autologin == false ? username != null && password != null : true);

    if (autologin == true) {
      bool loginStatus = await _checkLogin();
      if (loginStatus == true) {
        loginInformation = (StorageController.loadLoginInformation())!;
        return;
      }

      username = StorageController.loadUsername();
      password = StorageController.loadPassword();
    }

    if (username == null || password == null) {
      loginInformation.loginStatus = false;
      loginInformation.loginMsg = "?????????, ??????????????? ???????????? ?????? ????????????.";
      StorageController.storeLoginInformation(loginInformation);
      return;
    }

    String body = 'username=$username&password=${Uri.encodeQueryComponent(password)}';
    try {
      dio.Response response = await dio.Dio().post(
        CommonUrl.loginUrl,
        data: body,
        options: dio.Options(
          followRedirects: false,
          contentType: 'application/x-www-form-urlencoded',
          headers: {
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
          },
          validateStatus: (status) => status == 303,
        ),
      );

      /* wrong id/pw */
      if (response.headers.map['location']![0] == CommonUrl.loginErrorUrl) {
        loginInformation.loginMsg = '????????? ID ?????? PW?????????. ?????? ??????????????????.';
        loginInformation.loginStatus = false;
        StorageController.storeLoginInformation(loginInformation);
        return;
      }

      /* successfully login */
      loginInformation.moodleSessionKey = response.headers.map['set-cookie']![1];
      loginInformation.loginMsg = '????????? ??????!';
      await _getInformation(loginInformation);

      await _setCooKie(loginInformation);
      loginInformation.loginStatus = true;

      StorageController.storeUsername(username);
      StorageController.storePassword(password);
      StorageController.storeLoginInformation(loginInformation);

      printLog("Sync With Plato : ${loginInformation.moodleSessionKey}");

      return;
    } on dio.DioError catch (e, stacktrace) {
      printLog(e.type);
      if (e.type != dio.DioErrorType.other) {
        await ExceptionController.onExpcetion(stacktrace.toString(), false);
      }
      /* unknownError */

      loginInformation.loginMsg = '??? ??? ?????? ????????? ???????????? ??????????????????.(unknown)';
    }
    /* unknownError */
    catch (e) {
      loginInformation.loginMsg = '??? ??? ?????? ????????? ???????????? ??????????????????.(unkown2)';
      return;
    }
    return;
  }

  static Future<void> logout() async {
    final LoginInformation loginInformation = (StorageController.loadLoginInformation())!;

    String? sessionKey = await _getSessionKey(loginInformation.moodleSessionKey);
    if (sessionKey == null) return;
    try {
      await dio.Dio().get(CommonUrl.logoutUrl + sessionKey);
    } on dio.DioError catch (e, stacktrace) {
      if (e.type != dio.DioErrorType.other) {
        await ExceptionController.onExpcetion(stacktrace.toString(), false);
      }
    }

    StorageController.clearUserData();
    StorageController.clearAppSetting();

    return;
  }

  static Future<String?> _getSessionKey(final String moodleSessionKey) async {
    var options = dio.Options(headers: {'Cookie': moodleSessionKey});

    var response = await requestGet(CommonUrl.platoCalendarUrl, options: options, isFront: false);

    if (response == null) {
      throw Exception("response is null on _getSessionKey");
    }
    if (response.requestOptions.path == "null") {
      return null;
    }

    try {
      String data = response.data.toString();
      int sessionkeyIndex = data.indexOf('sesskey');
      String? sessionKey = data.substring(sessionkeyIndex + 10, data.indexOf(',', sessionkeyIndex) - 1);
      return sessionKey;
    } catch (e) {
      throw Exception("parsing error on _getSessionKey!\n$response");
    }
  }

  static Future<void> _getInformation(LoginInformation loginInformation) async {
    try {
      var response =
          await dio.Dio().get(CommonUrl.platoUserInformationUrl, options: dio.Options(headers: {"Cookie": loginInformation.moodleSessionKey}));

      if (response.data == null) {
        throw Exception("response.data is null on _getInformation");
      }
      Document document = parse(response.data);

      loginInformation.studentId = document.getElementById('fitem_id_idnumber')!.children[1].text.trim();
      loginInformation.department = document.getElementById('fitem_id_department')!.children[1].text.trim();
      loginInformation.name = document.getElementById('id_firstname')!.attributes['value']!.trim();
      loginInformation.imgUrl = document.getElementsByClassName('userpicture')[0].attributes['src']!;
      loginInformation.sessionKey =
          document.getElementsByTagName('input').firstWhere((element) => element.attributes['name'] == 'sesskey').attributes['value']!;
    } on dio.DioError catch (e, stacktrace) {
      if (e.type != dio.DioErrorType.other) {
        await ExceptionController.onExpcetion(stacktrace.toString(), false);
      }
    }

    return;
  }

  static Future<void> _setCooKie(final LoginInformation loginInformation) async {
    CookieManager cookieManager = CookieManager.instance();
    await cookieManager.deleteAllCookies();
    await cookieManager.setCookie(
      url: Uri.parse('https://plato.pusan.ac.kr'),
      name: 'MoodleSession',
      value: loginInformation.moodleSessionKey.split('=')[1],
      domain: 'plato.pusan.ac.kr',
      path: '/',
    );
  }
}
