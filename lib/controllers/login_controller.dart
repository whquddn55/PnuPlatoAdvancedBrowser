import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/login_information.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';
import 'package:dio/dio.dart' as dio;

class LoginController extends GetxController {
  static LoginController get to => Get.find<LoginController>();

  LoginInformation loginInformation = LoginInformation();

  static Future<bool> _checkLogin() async {
    final LoginInformation? loginInformation = StorageController.loadLoginInformation();
    if (loginInformation == null) return false;

    String body = '[{"index":0,"methodname":"core_fetch_notifications","args":{"contextid":2}}]';
    final dio.Options options = dio.Options(
      contentType: 'application/json',
      headers: {"X-Requested-With": "XMLHttpRequest"},
    );
    options.headers!["Cookie"] = loginInformation.moodleSessionKey;

    var response = await dio.Dio().post("https://plato.pusan.ac.kr/lib/ajax/service.php?info=core_fetch_notifications", data: body, options: options);

    printLog("checkLogin on front : ${response.data != null && response.data[0]["error"] == false}");
    return response.data != null && response.data[0]["error"] == false;
  }

  Future<void> login({required final bool autologin, String? username, String? password}) async {
    bool beforeLoginStatus = loginInformation.loginStatus;
    String beforeLoginMsg = loginInformation.loginMsg;
    if (await _checkLogin() == false) {
      await BackgroundLoginController.login(autologin: autologin, username: username, password: password);
    }

    final LoginInformation? _loginInformation = StorageController.loadLoginInformation();
    if (_loginInformation == null) return;
    loginInformation = _loginInformation;
    if (beforeLoginStatus != loginInformation.loginStatus || beforeLoginMsg != loginInformation.loginMsg) update();
  }

  Future<void> logout() async {
    bool before = loginInformation.loginStatus;
    var res = await BackgroundService.sendData(BackgroundServiceAction.logout);

    if (res == false) {
      /* TODO: 에러 */
      return;
    }

    loginInformation = LoginInformation();
    if (before != loginInformation.loginStatus) update();
    return;
  }
}
