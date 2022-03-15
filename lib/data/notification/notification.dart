import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

abstract class Notification {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final DateTime time;

  Notification({required this.title, required this.body, required this.url, required this.time});

  @factory
  static Notification fromJson(Map<String, dynamic> json) {
    switch (json["type"]) {
      case "ubboard":
        return ArticleNotification(title: json["title"], body: json["body"], url: json["url"], time: DateTime.parse(json["time"]));
      case "folder":
        return FolderNotification(title: json["title"], body: json["body"], url: json["url"], time: DateTime.parse(json["time"]));
      case "ubfile":
        return FileNotification(title: json["title"], body: json["body"], url: json["url"], time: DateTime.parse(json["time"]));
      case "url":
        return UrlNotification(title: json["title"], body: json["body"], url: json["url"], time: DateTime.parse(json["time"]));
      case "vod":
        return VodNotification(title: json["title"], body: json["body"], url: json["url"], time: DateTime.parse(json["time"]));
      case "zoom":
        return ZoomNotification(title: json["title"], body: json["body"], url: json["url"], time: DateTime.parse(json["time"]));
      case "assign":
        return AssignNotification(title: json["title"], body: json["body"], url: json["url"], time: DateTime.parse(json["time"]));
    }
    return UnknownNotification(title: json["title"], body: json["body"], url: json["url"], time: DateTime.parse(json["time"]));
  }

  @override
  int get hashCode => url.hashCode;
  @override
  bool operator ==(final Object other) => other.runtimeType == runtimeType && hashCode == other.hashCode;

  Color getColor();

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
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course, targetActivityId: url.split('?id=')[1])));
  }

  Future<void> show() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: hashCode,
        channelKey: 'ppab_noti_normal',
        title: title,
        body: body,
        payload: {"url": url},
        displayOnForeground: true,
        wakeUpScreen: true,
        displayOnBackground: true,
        showWhen: true,
      ),
    );
  }
}
