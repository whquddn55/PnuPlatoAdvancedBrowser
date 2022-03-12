import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
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
  final String title;
  final String body;
  final String url;
  final DateTime time;

  Notification({required this.title, required this.body, required this.url, required this.time});

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
      default:
        return UnknownNotification(title: json["title"], body: json["body"], url: json["url"], time: DateTime.parse(json["time"]));
    }
  }

  Map<String, dynamic> toJson() {
    String typeString = "unknown";
    switch (runtimeType) {
      case ArticleNotification:
        typeString = "ubboard";
        break;
      case FolderNotification:
        typeString = "folder";
        break;
      case FileNotification:
        typeString = "ubfile";
        break;
      case UrlNotification:
        typeString = "url";
        break;
      case VodNotification:
        typeString = "vod";
        break;
      case ZoomNotification:
        typeString = "zoom";
        break;
      case AssignNotification:
        typeString = "assign";
        break;
      case UnknownNotification:
        typeString = "unknown";
        break;
    }
    return {
      "title": title,
      "body": body,
      "url": url,
      "time": time.toString(),
      "type": typeString,
    };
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
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const android = AndroidNotificationDetails('thuthi_plato_noti', '플라토 브라우저 알림',
        channelDescription: '플라토 브라우저에서 새 알림을 보여줌', importance: Importance.max, priority: Priority.high);
    const detail = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(hashCode, title, body, detail, payload: url);
  }
}
