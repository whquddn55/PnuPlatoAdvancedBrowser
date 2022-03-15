import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_notification_controller.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_todo_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

enum BackgroundServiceAction { login, logout, fetchTodoList, fetchNotificationList, clearNotificationList }

/* APP 부분 */
abstract class BackgroundService {
  static final FlutterBackgroundService _service = FlutterBackgroundService();
  static final Map<int, Completer> _completerMap = <int, Completer>{};

  static Future<void> initializeService() async {
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onStart,
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

      printLog("recevied app: $data");

      BackgroundServiceAction action = BackgroundServiceAction.values.byName(data["action"]);
      switch (action) {
        case BackgroundServiceAction.login:
          throw UnimplementedError("백그라운드 서비스 login 호출");
          _completerMap[data["hashCode"]]?.complete(data["data"]);
          break;
        case BackgroundServiceAction.logout:
          _completerMap[data["hashCode"]]?.complete(data["data"]);
          break;
        case BackgroundServiceAction.fetchTodoList:
          _completerMap[data["hashCode"]]?.complete(data);

          break;
        case BackgroundServiceAction.fetchNotificationList:
          _completerMap[data["hashCode"]]?.complete(jsonDecode(data["data"]).map((map) => noti.Notification.fromJson(map)).toList());
          break;

        case BackgroundServiceAction.clearNotificationList:
          _completerMap[data["hashCode"]]?.complete(data["data"]);
          break;
      }
      _completerMap.remove(data["hashCode"]);
    });
  }

  static Future<dynamic> sendData(final BackgroundServiceAction action, {Map<String, dynamic>? data}) async {
    await _runService();

    var completer = Completer();
    _completerMap[completer.hashCode] = completer;

    if (data == null) {
      _service.sendData({"action": action.name, "hashCode": completer.hashCode});
    } else {
      _service.sendData({"action": action.name, "hashCode": completer.hashCode, ...data});
    }

    return completer.future;
  }

  static Future<void> _runService() async {
    if (await _service.isServiceRunning()) return;
    await _service.start();
  }
}

/* 서비스 부분 */
void _onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void _onStart() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    SharedPreferencesAndroid.registerWith();
    PathProviderAndroid.registerWith();
  }
  if (Platform.isIOS) {
    SharedPreferencesIOS.registerWith();
    PathProviderIOS.registerWith();
  }

  await BackgroundNotificationController.initialize();

  /* ensure login */
  await BackgroundLoginController.login(autologin: true, username: null, password: null);

  final service = FlutterBackgroundService();
  service.onDataReceived.listen((data) async {
    if (data == null) {
      return;
    }
    printLog("receive service: $data");

    var res = <String, dynamic>{"action": data["action"], "hashCode": data["hashCode"]};
    final BackgroundServiceAction action = BackgroundServiceAction.values.byName(data["action"]);
    switch (action) {
      case BackgroundServiceAction.login:
        throw UnimplementedError("백그라운드 서비스 login 호출");
        await BackgroundLoginController.login(autologin: data["autologin"], username: data["username"], password: data["password"]);
        res["data"] = BackgroundLoginController.loginInformation;
        service.sendData(res);
        break;
      case BackgroundServiceAction.logout:
        res["data"] = await BackgroundLoginController.logout();
        service.sendData(res);
        break;
      case BackgroundServiceAction.fetchTodoList:
        /* ensure login */
        await BackgroundLoginController.login(autologin: true, username: null, password: null);

        var courseIdList = List<String>.from(data["courseIdList"]);
        await BackgroundTodoController.fetchTodoList(courseIdList);
        service.sendData(res);
        break;
      case BackgroundServiceAction.fetchNotificationList:
        /* ensure login */
        await BackgroundLoginController.login(autologin: true, username: null, password: null);

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

    printLog("send service: ${res["data"].toString()}");
  });

  var pref = await SharedPreferences.getInstance();
  var lastFetchTodoTime = DateTime.fromMillisecondsSinceEpoch(pref.getInt("lastFetchTodoTime") ?? 0);
  if (DateTime.now().difference(lastFetchTodoTime).inSeconds >= 300) {
    timerBody();
  }

  Timer.periodic(
    const Duration(minutes: 3),
    (timer) async => timerBody(),
  );
}

Future<void> timerBody() async {
  await BackgroundNotificationController.updateNotificationList();

  var res = await requestGet(CommonUrl.notificationUrl + '1', isFront: false, retry: 1);
  if (res == null) {
    return;
  }

  await File(
          '/storage/emulated/0/Android/data/com.thuthi.PnuPlatoAdvancedBrowser.pnu_plato_advanced_browser/files/${DateFormat("MM-dd_HH:mm").format(DateTime.now())}.txt')
      .writeAsString(res.data, mode: FileMode.append);

  var pref = await SharedPreferences.getInstance();
  await pref.setInt("lastFetchTodoTime", DateTime.now().millisecondsSinceEpoch);
}
