import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/app_setting.dart';

class AppSettingController extends GetxController {
  static AppSettingController get to => Get.find<AppSettingController>();
  AppSetting _setting = AppSetting();

  Future<void> initialize() async {
    _setting = StorageController.loadAppSetting();
  }

  bool get isFirst => _setting.isFirst;
  set isFirst(final bool isFirst) {
    _setting.isFirst = isFirst;
    StorageController.storeAppSetting(_setting);
    update();
  }

  Color get vodColor => _setting.vodColor;
  set vodColor(final Color vodColor) {
    _setting.vodColor = vodColor;
    StorageController.storeAppSetting(_setting);
  }

  Color get assignColor => _setting.assignColor;
  set assignColor(final Color assignColor) {
    _setting.assignColor = assignColor;
    StorageController.storeAppSetting(_setting);
  }

  Color get zoomColor => _setting.zoomColor;
  set zoomColor(final Color zoomColor) {
    _setting.zoomColor = zoomColor;
    StorageController.storeAppSetting(_setting);
  }

  Color get folderColor => _setting.folderColor;
  set folderColor(final Color folderColor) {
    _setting.folderColor = folderColor;
    StorageController.storeAppSetting(_setting);
  }

  Color get articleColor => _setting.articleColor;
  set articleColor(final Color articleColor) {
    _setting.articleColor = articleColor;
    StorageController.storeAppSetting(_setting);
  }

  Color get unknownColor => _setting.unknownColor;
  set unknownColor(final Color unknownColor) {
    _setting.unknownColor = unknownColor;
    StorageController.storeAppSetting(_setting);
  }
}
