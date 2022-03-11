import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification.dart' as noti;
import 'package:pnu_plato_advanced_browser/data/todo.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_notification_controller.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_todo_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';

enum BackgroundServiceAction { login, logout, fetchTodoList, fetchNotificationList, clearNotificationList }

/* APP 부분 */
abstract class BackgroundService {
  static final FlutterBackgroundService _service = FlutterBackgroundService();
  static final Map<int, Completer> _completerMap = <int, Completer>{};

  static Future<void> initializeService() async {
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: _onStart,
        // auto start service
        autoStart: true,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
        // this will executed when app is in foreground in separated isolate
        onForeground: _onStart,
        // you have to enable background fetch capability on xcode project
        onBackground: _onIosBackground,
      ),
    );

    _service.onDataReceived.listen((data) {
      if (data == null) {
        return;
      }

      printLog("[DEBUG] recevied app: $data");

      BackgroundServiceAction action = BackgroundServiceAction.values.byName(data["action"]);

      switch (action) {
        case BackgroundServiceAction.login:
          _completerMap[data["hashCode"]]!.complete(data["data"]);
          break;
        case BackgroundServiceAction.logout:
          _completerMap[data["hashCode"]]!.complete(data["data"]);
          break;
        case BackgroundServiceAction.fetchTodoList:
          _completerMap[data["hashCode"]]!.complete(jsonDecode(data["data"]).map((map) => Todo.fromJson(map)).toList());
          break;
        case BackgroundServiceAction.fetchNotificationList:
          _completerMap[data["hashCode"]]!.complete(jsonDecode(data["data"]).map((map) => noti.Notification.fromJson(map)).toList());
          break;

        case BackgroundServiceAction.clearNotificationList:
          _completerMap[data["hashCode"]]!.complete(data["data"]);
          break;
      }
    });
  }

  static Future<dynamic> sendData(final BackgroundServiceAction action, {Map<String, dynamic>? data}) {
    var completer = Completer();
    _completerMap[completer.hashCode] = completer;

    if (data == null) {
      _service.sendData({"action": action.name, "hashCode": completer.hashCode});
    } else {
      _service.sendData({"action": action.name, "hashCode": completer.hashCode, ...data});
    }

    return completer.future;
  }
}

/* 서비스 부분 */
void _onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void _onStart() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
  if (Platform.isIOS) SharedPreferencesIOS.registerWith();

  await BackgroundNotificationController.initialize();

  printLog("Service start");

  final service = FlutterBackgroundService();
  service.onDataReceived.listen((data) async {
    if (data == null) {
      return;
    }

    BackgroundServiceAction action = BackgroundServiceAction.values.byName(data["action"]);

    printLog("[DEBUG] receive service: $data");

    var res = <String, dynamic>{"action": data["action"], "hashCode": data["hashCode"]};

    switch (action) {
      case BackgroundServiceAction.login:
        res["data"] = await BackgroundLoginController.login(autologin: data["autologin"], username: data["username"], password: data["password"]);
        service.sendData(res);
        break;
      case BackgroundServiceAction.logout:
        res["data"] = await BackgroundLoginController.logout();
        service.sendData(res);
        break;
      case BackgroundServiceAction.fetchTodoList:
        var courseIdList = List<String>.from(data["courseIdList"]);
        var vodStatusList = List<Map<String, dynamic>>.from(data["vodStatusList"]);
        res["data"] = jsonEncode((await BackgroundTodoController.fetchTodoList(courseIdList, vodStatusList)).map((todo) => todo.toJson()).toList());
        service.sendData(res);
        break;
      case BackgroundServiceAction.fetchNotificationList:
        await BackgroundNotificationController.updateNotificationList();
        res["data"] = jsonEncode(BackgroundNotificationController.notificationList.reversed.toList());
        service.sendData(res);
        break;
      case BackgroundServiceAction.clearNotificationList:
        await BackgroundNotificationController.clearNotificationList();
        res["data"] = true;
        service.sendData(res);
        break;
    }
  });

  Timer.periodic(
    const Duration(minutes: 3),
    (timer) async {
      final DateTime now = DateTime.now();
      printLog("currentTime : $now");
      var pref = await SharedPreferences.getInstance();

      var lastFetchTodoTime = DateTime.fromMillisecondsSinceEpoch(pref.getInt("lastFetchTodoTime") ?? 0);
      printLog("lastFetchTodoTime : $lastFetchTodoTime");

      File file = File(
          '/storage/emulated/0/Android/data/com.thuthi.PnuPlatoAdvancedBrowser.pnu_plato_advanced_browser/files/${DateFormat.Hms().format(now)}.txt');
      await file.writeAsString('');
      // if (BackgroundLoginController.loginStatus == false) {
      //   file.writeAsString('return', mode: FileMode.append);
      //   return;
      // }
      await BackgroundNotificationController.updateNotificationList();

      var res = await requestGet(CommonUrl.notificationUrl + '1', isFront: false, retry: 2);
      if (res == null) {
        await file.writeAsString('null', mode: FileMode.append);
        return;
      }

      await File(
              '/storage/emulated/0/Android/data/com.thuthi.PnuPlatoAdvancedBrowser.pnu_plato_advanced_browser/files/${DateFormat.Hms().format(now)}.txt')
          .writeAsString(res.data, mode: FileMode.append);
      await pref.setInt("lastFetchTodoTime", now.millisecondsSinceEpoch);
      printLog("successful!!");
    },
  );
}
