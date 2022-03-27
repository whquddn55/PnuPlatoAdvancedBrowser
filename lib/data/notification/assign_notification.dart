import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

class AssignNotification extends noti.Notification {
  AssignNotification({
    required String title,
    required String body,
    required String url,
    required DateTime time,
  }) : super(title: title, body: body, url: url, time: time, type: "assign");

  @override
  Color getColor() => AppSettingController.to.assignColor;

  // @override
  // bool operator ==(final Object other) => other.runtimeType == AssignNotification && hashCode == other.hashCode;
}
