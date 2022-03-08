import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSettingController {
  static late SharedPreferences _preference;
  static ThemeMode _themeMode = ThemeMode.light;
  static bool _isFirst = true;

  static ThemeMode get themeMode => _themeMode;
  static set themeMode(final ThemeMode themeMode) {
    _themeMode = themeMode;
    Get.changeThemeMode(themeMode);
    _preference.setInt("theme", themeMode.index);
    Restart.restartApp();
  }

  static bool get isFirst => _isFirst;
  static set isFirst(final bool isFirst) {
    _isFirst = isFirst;
    _preference.setBool('isFirst', isFirst);
  }

  static Future<void> initiate() async {
    _preference = await SharedPreferences.getInstance();
    int? themeIndex = _preference.getInt("theme");
    if (themeIndex == null) {
      _preference.setInt("theme", _themeMode.index);
    } else {
      _themeMode = ThemeMode.values.elementAt(themeIndex);
    }

    _isFirst = _preference.getBool('isFirst') ?? true;
  }
}
