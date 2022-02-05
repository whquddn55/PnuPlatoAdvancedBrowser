import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSettingController {
  static ThemeMode _themeMode = ThemeMode.system;
  static late SharedPreferences _preference;

  static ThemeMode get themeMode => _themeMode;

  static Future<void> initiate() async {
    _preference = await SharedPreferences.getInstance();
    int? themeIndex = _preference.getInt("theme");
    if (themeIndex == null) {
      _preference.setInt("theme", themeMode.index);
    } else {
      _themeMode = ThemeMode.values.elementAt(themeIndex);
    }
  }

  static void setTheme(final ThemeMode themeMode) {
    _themeMode = themeMode;
    Get.changeThemeMode(themeMode);
    _preference.setInt("theme", themeMode.index);
    Restart.restartApp();
  }
}
