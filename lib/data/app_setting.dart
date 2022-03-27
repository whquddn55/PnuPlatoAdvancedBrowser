import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';

@Entity()
class AppSetting {
  @Id(assignable: true)
  int dbId = StorageController.defaultAppSettingId;

  bool isFirst = true;

  Color vodColor = Colors.blue.withOpacity(0.7);
  Color assignColor = Colors.red.withOpacity(0.7);
  Color zoomColor = Colors.green.withOpacity(0.7);
  Color folderColor = Colors.orange.withOpacity(0.7);
  Color articleColor = Colors.purple.withOpacity(0.7);
  Color unknownColor = Colors.grey.withOpacity(0.7);
}
