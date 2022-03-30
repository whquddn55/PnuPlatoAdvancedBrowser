import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pnu_plato_advanced_browser/data/app_setting.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/data/db_order.dart';
import 'package:pnu_plato_advanced_browser/data/login_information.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/user_data.dart';
import 'package:pnu_plato_advanced_browser/objectbox.g.dart';

import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

abstract class StorageController {
  static const int defaultUserDataId = 1234;
  static const int _defaultNotificationId = 1236;
  static const int defaultAppSettingId = 1237;

  static late final Store _store;
  static Future<void> initialize() async {
    if (Platform.isAndroid) {
      PathProviderAndroid.registerWith();
    }
    if (Platform.isIOS) {
      PathProviderIOS.registerWith();
    }

    final downloadDirectory = Directory(await getDownloadDirectory());

    if (!(await downloadDirectory.exists())) {
      await downloadDirectory.create(recursive: true);
    }

    final String path = (await getApplicationDocumentsDirectory()).path + '/db';
    try {
      _store = await openStore(directory: path);
    } catch (e) {
      _store = Store.attach(getObjectBoxModel(), path);
    }
    if (_store.box<UserData>().get(defaultUserDataId) == null) {
      _store.box<UserData>().put(UserData());
    }
    if (_store.box<DBOrder>().get(_defaultNotificationId) == null) {
      _store.box<DBOrder>().put(DBOrder(id: _defaultNotificationId, idList: []));
    }
    if (_store.box<AppSetting>().get(defaultAppSettingId) == null) {
      _store.box<AppSetting>().put(AppSetting());
    }
  }

  static Future<void> clearAll() async {
    _store.box<UserData>().removeAll();
    _store.box<DBOrder>().removeAll();
    _store.box<AppSetting>().removeAll();
    _store.box<Course>().removeAll();
    _store.box<Todo>().removeAll();
    _store.box<Notification>().removeAll();
    _store.box<LoginInformation>().removeAll();
    _store.close();
  }

  static Future<String> getDownloadDirectory() async {
    return (await getApplicationDocumentsDirectory()).path + '/downloads';
  }

  static List<Course> loadCourseList() {
    final res = _store.box<Course>().getAll();
    res.sort((a, b) => a.dbId - b.dbId);
    return res;
  }

  static void storeCourseList(final List<Course> courseList) {
    _store.box<Course>().removeAll();
    _store.box<Course>().putMany(courseList);
  }

  static List<Todo> loadTodoList() {
    final res = _store.box<Todo>().getAll().map((todo) => todo.transType()).toList();
    res.sort((a, b) {
      if (a.dueDate == b.dueDate) {
        if (a.courseId == b.courseId) {
          if (a.type == b.type) {
            final int aId = int.parse(a.id);
            final int bId = int.parse(b.id);
            if (aId == bId) {
              return (a.userDefined ? 1 : 0) - (b.userDefined ? 1 : 0);
            }
            return aId.compareTo(bId);
          }
          return a.type.compareTo(b.type);
        }
        return int.parse(a.courseId).compareTo(int.parse(b.courseId));
      }
      return (a.dueDate ?? DateTime(0)).compareTo(b.dueDate ?? DateTime(0));
    });
    return res;
  }

  static void removeTodo(final Todo todo) {
    _store.box<Todo>().remove(todo.dbId);
  }

  static void storeTodoList(final List<Todo> todoList) {
    _store.box<Todo>().putMany(todoList);
  }

  static List<Notification> loadNotificationList() {
    final res = _store.box<Notification>().getAll().map((notification) => notification.transType()).toList();
    final notificationOrder = _store.box<DBOrder>().get(_defaultNotificationId)!.idList;
    res.sort((a, b) =>
        notificationOrder.indexWhere((bdId) => int.parse(bdId) == a.dbId) - notificationOrder.indexWhere((bdId) => int.parse(bdId) == b.dbId));
    return res;
  }

  static void storeNotificationList(final List<Notification> notificationList) {
    _store.box<Notification>().removeAll();
    _store.box<Notification>().putMany(notificationList);
    final todoOrder = DBOrder(id: _defaultNotificationId, idList: notificationList.map((notification) => notification.dbId.toString()).toList());
    _store.box<DBOrder>().put(todoOrder);
  }

  static LoginInformation? loadLoginInformation() {
    return _store.box<LoginInformation>().get(defaultUserDataId);
  }

  static void storeLoginInformation(final LoginInformation loginInformation) {
    _store.box<LoginInformation>().put(loginInformation);
  }

  static String loadUsername() {
    return _store.box<UserData>().get(defaultUserDataId)!.username;
  }

  static void storeUsername(final String username) {
    var userData = _store.box<UserData>().get(defaultUserDataId)!;
    userData.username = username;
    _store.box<UserData>().put(userData);
  }

  static String loadPassword() {
    return _store.box<UserData>().get(defaultUserDataId)!.password;
  }

  static void storePassword(final String password) {
    var userData = _store.box<UserData>().get(defaultUserDataId)!;
    userData.password = password;
    _store.box<UserData>().put(userData);
  }

  static DateTime loadLastNotiSyncTime() {
    return _store.box<UserData>().get(defaultUserDataId)!.lastNotiSyncTime;
  }

  static void storeLastNotiSyncTime(final DateTime lastNotiSyncTime) {
    var userData = _store.box<UserData>().get(defaultUserDataId)!;
    userData.lastNotiSyncTime = lastNotiSyncTime;
    _store.box<UserData>().put(userData);
  }

  static DateTime loadLastTodoSyncTime() {
    return _store.box<UserData>().get(defaultUserDataId)!.lastTodoSyncTime;
  }

  static void storeLastTodoSyncTime(final DateTime lastTodoSyncTime) {
    var userData = _store.box<UserData>().get(defaultUserDataId)!;
    userData.lastTodoSyncTime = lastTodoSyncTime;
    _store.box<UserData>().put(userData);
  }

  static storeAppSetting(final AppSetting appSetting) {
    _store.box<AppSetting>().put(appSetting);
  }

  static AppSetting loadAppSetting() {
    return _store.box<AppSetting>().get(defaultAppSettingId)!;
  }

  static void clearUserData() {
    var newUserData = UserData();
    _store.box<UserData>().put(newUserData);
  }

  static void clearAppSetting() {
    var newAppSetting = AppSetting();
    _store.box<AppSetting>().put(newAppSetting);
  }
}
