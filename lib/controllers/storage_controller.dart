import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnu_plato_advanced_browser/data/login_information.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/user_data.dart';

abstract class StorageController {
  static late final Isar isar;
  static Future<void> initialize() async {
    final dir = await getApplicationSupportDirectory();
    print(dir);
    print(await getApplicationDocumentsDirectory());
    /* register HiveAdapters */
    isar = await Isar.open(
      directory: dir.path,
      schemas: [
        LoginInformationSchema,
        NotificationSchema,
        TodoSchema,
        UserDataSchema,
      ],
      inspector: true,
    );
    await isar.writeTxn((isar) async {
      if ((await isar.userDatas.get(0)) == null) {
        await isar.userDatas.put(UserData());
      }
    });
  }

  static Future<List<Todo>> loadTodoList() async {
    var todoList = await isar.txn<List<Todo>>((isar) async {
      return await isar.todos.filter().indexGreaterThan(-1).findAll();
    });
    return todoList.map((todo) => todo.transType()).toList();
  }

  static Future<void> storeTodoList(final List<Todo> todoList) async {
    final List<int> idList = await isar.writeTxn<List<int>>((isar) async {
      return await isar.todos.putAll(todoList);
    });

    for (int i = 0; i < todoList.length; ++i) {
      todoList[i].isarId = idList[i];
    }
  }

  static Future<List<Notification>> loadNotificationList() async {
    var notificationList = await isar.txn<List<Notification>>((isar) async {
      return await isar.notifications.filter().timeGreaterThan(DateTime(0)).findAll();
    });
    return notificationList.map((notification) => notification.transType()).toList();
  }

  static Future<void> storeNotificationList(final List<Notification> notificationList) async {
    final List<int> idList = await isar.writeTxn<List<int>>((isar) async {
      return await isar.notifications.putAll(notificationList);
    });

    for (int i = 0; i < notificationList.length; ++i) {
      notificationList[i].isarId = idList[i];
    }
  }

  static Future<LoginInformation?> loadLoginInformation() async {
    return await isar.txn<LoginInformation?>((isar) async {
      LoginInformation? res = await isar.loginInformations.get(0);
      return res;
    });
  }

  static Future<void> storeLoginInformation(final LoginInformation loginInformation) async {
    await isar.writeTxn<int>((isar) async {
      return await isar.loginInformations.put(loginInformation);
    });
  }

  static Future<String> loadUsername() async {
    return await isar.txn<String>((isar) async {
      return (await isar.userDatas.get(0))!.username;
    });
  }

  static Future<void> storeUsername(final String username) async {
    await isar.writeTxn((isar) async {
      UserData userdata = (await isar.userDatas.get(0))!;
      userdata.username = username;
      await isar.userDatas.put(userdata);
    });
  }

  static Future<String> loadPassword() async {
    return await isar.txn<String>((isar) async {
      return (await isar.userDatas.get(0))!.password;
    });
  }

  static Future<void> storePassword(final String password) async {
    await isar.writeTxn((isar) async {
      UserData userdata = (await isar.userDatas.get(0))!;
      userdata.password = password;
      await isar.userDatas.put(userdata);
    });
  }

  static Future<DateTime> loadLastSyncTime() async {
    return await isar.txn<DateTime>((isar) async {
      return (await isar.userDatas.get(0))!.lastSyncTime;
    });
  }

  static Future<void> storeLastSyncTime(final DateTime lastSyncTime) async {
    await isar.writeTxn((isar) async {
      UserData userdata = (await isar.userDatas.get(0))!;
      userdata.lastSyncTime = lastSyncTime;
      await isar.userDatas.put(userdata);
    });
  }

  static Future<bool> loadIsFirst() async {
    return await isar.txn<bool>((isar) async {
      return (await isar.userDatas.get(0))!.isFirst;
    });
  }

  static Future<void> storeIsFirst(final bool isFirst) async {
    await isar.writeTxn((isar) async {
      UserData userdata = (await isar.userDatas.get(0))!;
      userdata.isFirst = isFirst;
      await isar.userDatas.put(userdata);
    });
  }

  static Future<void> clearUserData() async {
    await isar.writeTxn((isar) async {
      var userData = UserData();
      userData.isFirst = false;
      await isar.userDatas.put(userData);
    });
  }
}
