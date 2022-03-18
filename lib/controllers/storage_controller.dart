import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnu_plato_advanced_browser/data/db_order.dart';
import 'package:pnu_plato_advanced_browser/data/login_information.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/user_data.dart';
import 'package:pnu_plato_advanced_browser/objectbox.g.dart';

abstract class StorageController {
  static const int defaultUserDataId = 1234;
  // static const int _defaultTodoListId = 1235;
  static const int _defaultNotificationId = 1236;

  static late final Store store;
  static Future<void> initialize() async {
    final String path = (await getApplicationDocumentsDirectory()).path + '/db';
    try {
      store = await openStore(directory: path);
    } catch (e) {
      store = Store.attach(getObjectBoxModel(), path);
    }
    if (store.box<UserData>().get(defaultUserDataId) == null) {
      store.box<UserData>().put(UserData());
    }
    if (store.box<DBOrder>().get(_defaultNotificationId) == null) {
      store.box<DBOrder>().put(DBOrder(id: _defaultNotificationId, idList: []));
    }
  }

  static List<Todo> loadTodoList() {
    final res = store.box<Todo>().getAll().map((todo) => todo.transType()).toList();
    res.sort((a, b) {
      if (a.dueDate == b.dueDate) {
        if (a.courseId == b.courseId) {
          if (a.index == b.index) {
            return (a.userDefined ? 1 : 0) - (b.userDefined ? 1 : 0);
          }
          return a.index - b.index;
        }
        return int.parse(a.courseId) - int.parse(b.courseId);
      }
      return (a.dueDate ?? DateTime(0)).compareTo(b.dueDate ?? DateTime(0));
    });
    return res;
  }

  static void storeTodoList(final List<Todo> todoList) {
    store.box<Todo>().putMany(todoList);
  }

  static List<Notification> loadNotificationList() {
    final res = store.box<Notification>().getAll().map((notification) => notification.transType()).toList();
    final notificationOrder = store.box<DBOrder>().get(_defaultNotificationId)!.idList;
    res.sort((a, b) =>
        notificationOrder.indexWhere((bdId) => int.parse(bdId) == a.dbId) - notificationOrder.indexWhere((bdId) => int.parse(bdId) == b.dbId));
    return res;
  }

  static void storeNotificationList(final List<Notification> notificationList) {
    store.box<Notification>().putMany(notificationList);
    final todoOrder = DBOrder(id: _defaultNotificationId, idList: notificationList.map((notification) => notification.dbId.toString()).toList());
    store.box<DBOrder>().put(todoOrder);
  }

  static LoginInformation? loadLoginInformation() {
    return store.box<LoginInformation>().get(defaultUserDataId);
  }

  static void storeLoginInformation(final LoginInformation loginInformation) {
    store.box<LoginInformation>().put(loginInformation);
  }

  static String loadUsername() {
    return store.box<UserData>().get(defaultUserDataId)!.username;
  }

  static void storeUsername(final String username) {
    var userData = store.box<UserData>().get(defaultUserDataId)!;
    userData.username = username;
    store.box<UserData>().put(userData);
  }

  static String loadPassword() {
    return store.box<UserData>().get(defaultUserDataId)!.password;
  }

  static void storePassword(final String password) {
    var userData = store.box<UserData>().get(defaultUserDataId)!;
    userData.password = password;
    store.box<UserData>().put(userData);
  }

  static DateTime loadLastSyncTime() {
    return store.box<UserData>().get(defaultUserDataId)!.lastSyncTime;
  }

  static void storeLastSyncTime(final DateTime lastSyncTime) {
    var userData = store.box<UserData>().get(defaultUserDataId)!;
    userData.lastSyncTime = lastSyncTime;
    store.box<UserData>().put(userData);
  }

  static bool loadIsFirst() {
    return store.box<UserData>().get(defaultUserDataId)!.isFirst;
  }

  static void storeIsFirst(final bool isFirst) {
    var userData = store.box<UserData>().get(defaultUserDataId)!;
    userData.isFirst = isFirst;
    store.box<UserData>().put(userData);
  }

  static void clearUserData() {
    var newUserData = UserData();
    store.box<UserData>().put(newUserData);
  }
}
