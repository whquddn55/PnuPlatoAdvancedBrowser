import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSettingController extends GetxController {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  Future<void> toggleTheme() async {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(_themeMode);
    await Get.forceAppUpdate();
  }
}
