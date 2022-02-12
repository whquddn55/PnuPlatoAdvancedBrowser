import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataController extends GetxController {
  bool _loginStatus = false;
  String _sessionKey = '';
  String _moodleSessionKey = '';
  String _loginMsg = '';
  String _debugMsg = '';

  int _studentId = 123456789;
  String _name = 'thuthi';
  String _department = '전기컴퓨터공학부';
  String _imgUrl = CommonUrl.defaultAvatarUrl;
  String _lastSyncTime = DateTime(1946, 05, 15).toString();

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

  Future<void> login({required final bool autologin, String? username, String? password}) async {
    var backgroundService = Get.find<BackgroundService>();
    backgroundService.sendData(BackgroundServiceAction.login, data: {"autologin": autologin, "username": username, "password": password});
    var res = await backgroundService.loginCompleter.future;

    print(res);

    _loginStatus = res["loginStatus"];
    _loginMsg = res["loginMsg"];
    _debugMsg = res["debugMsg"];
    if (_loginStatus == true) {
      _moodleSessionKey = res["moodleSessionKey"];
      _studentId = res["studentId"];
      _department = res["department"];
      _name = res["name"];
      _imgUrl = res["imgUrl"];
    }

    update();
  }

  Future<bool> logout() async {
    bool sessionkeyRes = await _getSessionKey();
    if (sessionkeyRes == false) {
      return false;
    }
    await dio.Dio().get(CommonUrl.logoutUrl + _sessionKey);

    final preference = await SharedPreferences.getInstance();
    await preference.clear();
    _loginStatus = false;
    _sessionKey = '';
    _moodleSessionKey = '';
    _loginMsg = '';
    _debugMsg = '';
    _studentId = 123456789;
    _name = 'thuthi';
    _department = '전기컴퓨터공학부';
    _imgUrl = CommonUrl.defaultAvatarUrl;
    _lastSyncTime = DateTime(1946, 05, 15).toString();
    _loginStatus = false;
    update();
    return true;
  }

  Future<bool> getNotifications() async {
    var options = dio.Options(headers: {'Cookie': _moodleSessionKey});
    var response = await request(CommonUrl.notificationUrl, options: options, callback: login);

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
        var noti = Notification(id: ++i, title: '$title($timeago)', body: '[$type]$body', url: url);
        print('$url, $title, $timeago, $type');
        await noti.notify();
      }
    }

    return true;
  }

  void _updateSyncTime() {
    var now = DateTime.now();
    _lastSyncTime = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString();
  }

  Future<bool> _getInformation() async {
    var options = dio.Options(headers: {'Cookie': _moodleSessionKey});
    var response = await request(CommonUrl.platoUserInformationUrl, options: options);

    if (response == null) {
      /* TODO: 에러 */

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
    var options = dio.Options(headers: {'Cookie': _moodleSessionKey});
    var response = await request(url, options: options, callback: login);
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

  Future<bool> _getSessionKey() async {
    var options = dio.Options(headers: {'Cookie': _moodleSessionKey});

    var response = await request(CommonUrl.platoCalendarUrl, options: options);

    if (response == null) {
      /* TODO: 에러 */

      return false;
    }

    try {
      String data = response.data.toString();
      int sessionkeyIndex = data.indexOf('sesskey');
      _sessionKey = data.substring(sessionkeyIndex + 10, data.indexOf(',', sessionkeyIndex) - 1);
    } catch (e) {
      _loginMsg = '세션키를 가져오는데에 문제가 발생했습니다.';
      _debugMsg = 'response : ${response.data}';
      return false;
    }
    return true;
  }
}
