import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

class FileNotification extends noti.Notification {
  FileNotification({
    required String title,
    required String body,
    required String url,
    required DateTime time,
  }) : super(title: title, body: body, url: url, time: time, type: "ubfile");

  @override
  Color getColor() => AppSettingController.to.folderColor;

  // @override
  // bool operator ==(final Object other) => other.runtimeType == FileNotification && hashCode == other.hashCode;
}
