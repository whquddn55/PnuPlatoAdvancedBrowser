import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

part 'assign_notification.g.dart';

@HiveType(typeId: 7)
class AssignNotification extends noti.Notification {
  AssignNotification({required String title, required String body, required String url, required DateTime time})
      : super(title: title, body: body, url: url, time: time);

  @override
  Color getColor() => assignColor;

  // @override
  // bool operator ==(final Object other) => other.runtimeType == AssignNotification && hashCode == other.hashCode;
}
