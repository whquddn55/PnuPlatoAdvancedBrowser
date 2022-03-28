import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/article_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/assign_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/file_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/folder_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/unknown_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/url_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/vod_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/zoom_notification.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';
import 'package:objectbox/objectbox.dart';

import '../../objectbox.g.dart';

@Entity()
class Notification {
  @Id(assignable: true)
  int dbId;
  final String url;
  final String title;
  final String body;
  final DateTime time;
  final String type;

  Notification({
    required this.title,
    required this.body,
    required this.url,
    required this.time,
    required this.type,
  }) : dbId = url.hashCode;

  Notification transType() {
    switch (type) {
      case "ubboard":
        return ArticleNotification(title: title, body: body, url: url, time: time);
      case "folder":
        return FolderNotification(title: title, body: body, url: url, time: time);
      case "ubfile":
        return FileNotification(title: title, body: body, url: url, time: time);
      case "url":
        return UrlNotification(title: title, body: body, url: url, time: time);
      case "vod":
        return VodNotification(title: title, body: body, url: url, time: time);
      case "zoom":
        return ZoomNotification(title: title, body: body, url: url, time: time);
      case "assign":
        return AssignNotification(title: title, body: body, url: url, time: time);
      case "removed":
        return UnknownNotification(title: title, body: body, url: url, time: time);
      default:
        return UnknownNotification(title: title, body: body, url: url, time: time);
    }
  }

  @override
  int get hashCode => dbId;
  @override
  bool operator ==(final Object other) => (other is Notification) && hashCode == other.hashCode;

  Color getColor() {
    throw UnimplementedError("getcolor on notification");
  }

  void open(final BuildContext context) {
    final course = CourseController.getCourseByTitle(title);
    if (course == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("에러"),
          content: const Text("강의를 찾을 수 없습니다."),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
      return;
    }
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) => CourseMainPage(course: course, targetActivityId: url.split('?id=')[1])));
  }

  Future<void> show() async {
    await NotificationController.showNotification(NotificationType.plato, hashCode, title, body, {url: url});
  }
}
