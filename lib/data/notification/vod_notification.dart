import 'dart:ui';

import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

class VodNotification extends noti.Notification {
  VodNotification({
    required String title,
    required String body,
    required String url,
    required DateTime time,
  }) : super(title: title, body: body, url: url, time: time, type: "vod");

  @override
  Color getColor() => vodColor;

  // @override
  // bool operator ==(final Object other) => other.runtimeType == VodNotification && hashCode == other.hashCode;
}
