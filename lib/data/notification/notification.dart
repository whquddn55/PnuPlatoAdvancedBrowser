import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/article_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/assign_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/file_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/folder_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/unknown_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/url_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/vod_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/zoom_notification.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

part 'notification.g.dart';

@Collection()
class Notification {
  @Id()
  int? isarId;
  final String? url;
  final String title;
  final String body;
  final DateTime time;
  final String type;

  Notification({
    this.isarId,
    required this.title,
    required this.body,
    required this.url,
    required this.time,
    required this.type,
  });

  Notification transType() {
    switch (type) {
      case "article":
        return ArticleNotification(isarId: isarId, title: title, body: body, url: url, time: time);
      case "folder":
        return FolderNotification(isarId: isarId, title: title, body: body, url: url, time: time);
      case "ubfile":
        return FileNotification(isarId: isarId, title: title, body: body, url: url, time: time);
      case "url":
        return UrlNotification(isarId: isarId, title: title, body: body, url: url, time: time);
      case "vod":
        return VodNotification(isarId: isarId, title: title, body: body, url: url, time: time);
      case "zoom":
        return ZoomNotification(isarId: isarId, title: title, body: body, url: url, time: time);
      case "assign":
        return AssignNotification(isarId: isarId, title: title, body: body, url: url, time: time);
      case "removed":
        return UnknownNotification(isarId: isarId, title: title, body: body, url: url, time: time);
      default:
        return UnknownNotification(isarId: isarId, title: title, body: body, url: url, time: time);
    }
  }

  @override
  int get hashCode => url.hashCode;
  @override
  bool operator ==(final Object other) => other.runtimeType == runtimeType && hashCode == other.hashCode;

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
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course, targetActivityId: url!.split('?id=')[1])));
  }

  Future<void> show() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: hashCode,
        channelKey: 'ppab_noti_normal',
        title: title,
        body: body,
        payload: {"url": url ?? ""},
        displayOnForeground: true,
        wakeUpScreen: true,
        displayOnBackground: true,
        showWhen: true,
      ),
    );
  }
}
