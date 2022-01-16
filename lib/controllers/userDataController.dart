import 'dart:developer';

import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:dio/dio.dart' as Dio;
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/notificationController.dart';

class UserDataController extends GetxController {
  String _username = '', _password = '';
  bool _loginStatus = false;
  String _sessionKey = '';
  String _moodleSessionKey = '';
  String _loginMsg = '';
  String _debugMsg = '';

  int _studentId = 123456789;
  String _name = 'thuthi';
  String _department = '전기컴퓨터공학부';
  String _imgUrl = 'https://plato.pusan.ac.kr/theme/image.php/coursemosv2/core/1636448872/u/f1';
  String _lastSyncTime = DateTime(1946, 05, 15).toString();

  String get username => _username;
  String get password => _password;
  bool get loginStatus => _loginStatus;
  String get sessionKey => _sessionKey;
  String get moodleSessionKey => _moodleSessionKey;
  String get loginMsg => _loginMsg;
  String get debugMsg => _debugMsg;

  int get studentId => _studentId;
  String get name => _name;
  String get department => _department;
  String get imgUrl => _imgUrl;
  String get lastSyncTime => _lastSyncTime;

  set username(String username) => _username = username;
  set password(String password) => _password = password;

  Future<bool> login() async {
    String body = 'username=$_username&password=${Uri.encodeQueryComponent(_password)}';
    Dio.Response response;
    try {
      response = await Dio.Dio().post(
          'https://plato.pusan.ac.kr/login/index.php',
          data: body,
          options: Dio.Options(
              followRedirects : false,
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
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
                'Referer': 'https://plato.pusan.ac.kr/',
                'Accept-Encoding': 'gzip, deflate',
                'Accept-Language': 'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7',
              }
          ));

      /* always return 303 */
      _debugMsg = 'does not return 303';
      _loginMsg = 'login failed with UnknownError';
      /* TODO: popup error report */
      return _loginStatus = false;
    }
    on Dio.DioError catch (e, _) {
      /* successfully login */
      if(e.response!.statusCode == 303) {
        response = e.response!;
      }
      /* unknownError */
      else {
        _debugMsg = e.toString();
        _loginMsg = 'login failed with UnknownError';
        /* TODO: popup error report */
        return _loginStatus = false;
      }
    }
    /* unknownError */
    catch (e) {
      _debugMsg = e.toString();
      _loginMsg = 'login failed with UnknownError';
      /* TODO: popup error report */
      return _loginStatus = false;
    }

    /* wrong id/pw */
    if (response.headers.map['location']![0] == 'https://plato.pusan.ac.kr/login.php?errorcode=3') {
      _debugMsg = 'login failed with wrong ID/PW';
      _loginMsg = 'wrong ID/PW';
      return _loginStatus = false;
    }

    /* successfully login */
    _moodleSessionKey = response.headers.map['set-cookie']![1];
    _debugMsg = 'login success';
    _loginMsg = 'login success';

    _updateSyncTime();
    await _getInformation();
    update();
    return _loginStatus = true;
  }

  Future<bool> logout() async {
    bool sessionkeyRes = await _getSessionKey();
    if (sessionkeyRes == false) {
      return false;
    }
    await Dio.Dio().get('https://plato.pusan.ac.kr/login/logout.php?sesskey=$_sessionKey');
    _username = '';
    _password = '';
    _loginStatus = false;
    _sessionKey = '';
    _moodleSessionKey = '';
    _loginMsg = '';
    _debugMsg = '';
    _studentId = 123456789;
    _name = 'thuthi';
    _department = '전기컴퓨터공학부';
    _imgUrl = 'https://plato.pusan.ac.kr/theme/image.php/coursemosv2/core/1636448872/u/f1';
    _lastSyncTime = DateTime(1946, 05, 15).toString();
    _loginStatus = false;
    update();
    return true;
  }

  Future<bool> getNotifications() async {
    var options = Dio.Options(
        headers: {
          'Cookie': _moodleSessionKey
        });
    var response = await request('https://plato.pusan.ac.kr/local/ubnotification/', options: options, callback: login);

    if (response == null) {
      /* TODO: ERR */

      return false;
    }

    Document document = parse(response.data);
    int i = 0;
    /* TODO: 파일 추가해야 됨 */
    const TYPENAMES = {'ubboard': '공지사항', 'assign': '과제', 'vod': '동영상', 'quiz': '퀴즈'};
    for (var element in document.getElementsByClassName("well wellnopadding")[0].children) {
      if (element.localName == 'a') {
        String url = element.attributes['href']!;
        String title = element.getElementsByClassName('media-heading')[0].text
            .split(' ')[0];
        String timeago = element.getElementsByClassName('timeago')[0].innerHtml;
        String type = TYPENAMES[url.split('/')[4]]!;
        String body = await _getBody(url, type);
        var notiObject = NotificationObject(
            id: ++i, title: '$title($timeago)', body: '[$type]$body', url: url);
        print('$url, $title, $timeago, $type');
        await notiObject.notify();
      }
    }

    return true;
  }

  void _updateSyncTime() {
    var now = DateTime.now();
    _lastSyncTime = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString();
  }

  Future<bool> _getInformation() async {
    var options = Dio.Options(
        headers: {
          'Cookie': _moodleSessionKey
        });
    var response = await request('https://plato.pusan.ac.kr/user/user_edit.php', options: options);

    if (response == null) {
      /* TODO: ERR */

      return false;
    }
    Document document = parse(response.data);
    _studentId = int.parse(document.getElementById('fitem_id_idnumber')!.children[1].text.trim());
    _department = document.getElementById('fitem_id_department')!.children[1].text.trim();
    _name = document.getElementById('id_firstname')!.attributes['value']!.trim();
    _imgUrl = document.getElementsByClassName('userpicture')[0].attributes['src']!;

    return true;
  }

  Future<String> _getBody(String url, String type) async {
    var options = Dio.Options(
        headers: {
          'Cookie': _moodleSessionKey
        });
    var response = await request(url, options: options, callback: login);
    if (response == null) {
      return 'Undefined1';
    }
    Document document = parse(response.data);
    if (type == '공지사항') {
      return document.getElementsByTagName('h3')[0].text;
    }
    else if (type == '과제' || type == '동영상' || type == '퀴즈') {
      return document.getElementsByClassName('breadcrumb')[0].children.last.children[0].text;
    }
    /* TODO: Error */

    return 'Undefined2';
  }

  Future<bool> _getSessionKey() async {
    var options = Dio.Options(
        headers: {
          'Cookie': _moodleSessionKey
        });


    var response = await request('https://plato.pusan.ac.kr/calendar/export.php', options: options);

    if (response == null) {
      /* TODO: ERR */

      return false;
    }

    try {
      String data = response.data.toString();
      int sessionkeyIndex = data.indexOf('sesskey');
      _sessionKey = data.substring(
          sessionkeyIndex + 10, data.indexOf(',', sessionkeyIndex) - 1);
    }
    catch (e) {
      _loginMsg = '세션키를 가져오는데에 문제가 발생했습니다.';
      _debugMsg = 'response : ${response.data}';
      return false;
    }
    return true;
  }
}