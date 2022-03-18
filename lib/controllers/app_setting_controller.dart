import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';

abstract class AppSettingController {
  static bool _isFirst = true;

  static bool get isFirst => _isFirst;
  static set isFirst(final bool isFirst) {
    _isFirst = isFirst;
    StorageController.storeIsFirst(isFirst);
  }

  static Future<void> initilize() async {
    _isFirst = StorageController.loadIsFirst();
  }
}
