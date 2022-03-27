import 'dart:ui';

import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

class ZoomNotification extends noti.Notification {
  ZoomNotification({
    required String title,
    required String body,
    required String url,
    required DateTime time,
  }) : super(title: title, body: body, url: url, time: time, type: "zoom");

  @override
  Color getColor() => AppSettingController.to.zoomColor;

  // @override
  // bool operator ==(final Object other) => other.runtimeType == ZoomNotification && hashCode == other.hashCode;
}
