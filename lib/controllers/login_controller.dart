import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

class LoginController extends GetxController {
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
    BackgroundService.sendData(BackgroundServiceAction.login, data: {"autologin": autologin, "username": username, "password": password});
    var res = await BackgroundService.loginCompleter.future;

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

  Future<void> logout() async {
    BackgroundService.sendData(BackgroundServiceAction.logout);
    var res = await BackgroundService.logoutCompleter.future;

    if (res == false) {
      /* TODO: 에러 */
      return;
    }

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
    return;
  }
}
