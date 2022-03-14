import 'dart:convert';

import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/data/login_information.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class LoginController extends GetxController {
  static LoginController get to => Get.find<LoginController>();

  LoginInformation loginInformation = LoginInformation();

  static Future<bool> _checkLogin() async {
    final preference = await SharedPreferences.getInstance();
    if (preference.getString("loginInformation") == null) return false;
    final LoginInformation loginInformation = LoginInformation.fromJson(jsonDecode(preference.getString("loginInformation")!));

    String body = '[{"index":0,"methodname":"core_fetch_notifications","args":{"contextid":2}}]';
    final dio.Options options = dio.Options(
      contentType: 'application/json',
      headers: {"X-Requested-With": "XMLHttpRequest"},
    );
    options.headers!["Cookie"] = loginInformation.moodleSessionKey;

    var response = await dio.Dio().post("https://plato.pusan.ac.kr/lib/ajax/service.php?info=core_fetch_notifications", data: body, options: options);
    return response.data != null && response.data[0]["error"] == false;
  }

  Future<void> login({required final bool autologin, String? username, String? password}) async {
    final preference = await SharedPreferences.getInstance();

    bool before = loginInformation.loginStatus;
    if (await _checkLogin() == false) {
      await BackgroundLoginController.login(autologin: autologin, username: username, password: password);
    }

    if (preference.getString("loginInformation") == null) return;
    loginInformation = LoginInformation.fromJson(jsonDecode(preference.getString("loginInformation")!));
    if (before != loginInformation.loginStatus) update();
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
