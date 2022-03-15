import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnu_plato_advanced_browser/data/notification/article_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/assign_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/file_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/folder_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/unknown_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/url_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/vod_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/zoom_notification.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/quiz_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/unknown_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';

abstract class HiveController {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    /* register HiveAdapters */
    Hive.registerAdapter(TodoStatusAdapter());
    Hive.registerAdapter(AssignTodoAdapter());
    Hive.registerAdapter(QuizTodoAdapter());
    Hive.registerAdapter(UnknownTodoAdapter());
    Hive.registerAdapter(VodTodoAdapter());
    Hive.registerAdapter(ZoomTodoAdapter());
    Hive.registerAdapter(ArticleNotificationAdapter());
    Hive.registerAdapter(AssignNotificationAdapter());
    Hive.registerAdapter(FileNotificationAdapter());
    Hive.registerAdapter(FolderNotificationAdapter());
    Hive.registerAdapter(UnknownNotificationAdapter());
    Hive.registerAdapter(UrlNotificationAdapter());
    Hive.registerAdapter(VodNotificationAdapter());
    Hive.registerAdapter(ZoomNotificationAdapter());
  }

  static Future<void> clearByKey(final String key) async {
    final box = await Hive.openBox("userData");
    await box.delete(key);
    await box.close();
  }

  static Future<List<Todo>> loadTodoList() async {
    final box = await Hive.openBox("userData");
    final res = List<Todo>.from(box.get("todoList") ?? []);
    await box.close();
    return res;
  }

  static Future<void> storeTodoList(final List<Todo> todoList) async {
    final box = await Hive.openBox("userData");
    await box.put("todoList", todoList);
    await box.close();
  }

  static Future<List<Notification>> loadNotificationList() async {
    final box = await Hive.openBox("userData");
    final res = List<Notification>.from(box.get("notificationList") ?? []);
    await box.close();
    return res;
  }

  static Future<void> storeNotificationList(final List<Notification> notificationList) async {
    final box = await Hive.openBox("userData");
    await box.put("notificationList", notificationList);
    await box.close();
  }

  static Future<DateTime> loadLastTodoFetchTime() async {
    final box = await Hive.openBox("userData");
    final res = box.get("lastTodoFetchTime") ?? 0;
    await box.close();
    return DateTime.fromMillisecondsSinceEpoch(res);
  }

  static Future<void> storeLastTodoFetchTime(final DateTime lastTodoFetchTime) async {
    final box = await Hive.openBox("userData");
    await box.put("lastTodoFetchTime", lastTodoFetchTime.millisecondsSinceEpoch);
    await box.close();
  }
}
