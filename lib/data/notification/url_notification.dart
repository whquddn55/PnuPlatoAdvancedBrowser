import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

part 'url_notification.g.dart';

@HiveType(typeId: 11)
class UrlNotification extends noti.Notification {
  UrlNotification({required String title, required String body, required String url, required DateTime time})
      : super(title: title, body: body, url: url, time: time);

  @override
  Color getColor() => unknownColor;

  // @override
  // bool operator ==(final Object other) => other.runtimeType == UrlNotification && hashCode == other.hashCode;
}
