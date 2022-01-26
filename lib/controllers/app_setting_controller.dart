import 'package:get/get.dart';

class AppSettingController extends GetxController {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  set isDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    update();
  }
}
