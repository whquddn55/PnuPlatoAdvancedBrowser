import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

part 'file_notification.g.dart';

@HiveType(typeId: 8)
class FileNotification extends noti.Notification {
  FileNotification({required String title, required String body, required String url, required DateTime time})
      : super(title: title, body: body, url: url, time: time);

  @override
  Color getColor() => folderColor;

  // @override
  // bool operator ==(final Object other) => other.runtimeType == FileNotification && hashCode == other.hashCode;
}
