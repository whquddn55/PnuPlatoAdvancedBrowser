import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_notification_controller.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_todo_controller.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/bakcground_download_controller.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';

enum BackgroundServiceAction { logout, fetchTodoListAll, fetchTodoList, fetchNotificationList, download, update }

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

    _service.onDataReceived.listen((data) async {
      if (data == null) {
        return;
      }
      printLog("recevied app: $data");

      if (data["error"] != null) {}

      BackgroundServiceAction action = BackgroundServiceAction.values.byName(data["action"]);
      if (action == BackgroundServiceAction.update) {
        TodoController.to.updateTodoList();
      } else {
        _completerMap[data["hashCode"]]?.complete(data);
        _completerMap.remove(data["hashCode"]);
      }
    });
  }

  static Future<dynamic> sendData(final BackgroundServiceAction action, {Map<String, dynamic>? data}) async {
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

  if (Platform.isIOS) FlutterBackgroundServiceIOS.registerWith();
  if (Platform.isAndroid) FlutterBackgroundServiceAndroid.registerWith();

  await StorageController.initialize();
  await BackgroundNotificationController.initialize();

  /* ensure login */
  await BackgroundLoginController.login(autologin: true, username: null, password: null);

  final service = FlutterBackgroundService();

  service.onDataReceived.listen((data) async {
    if (data == null) {
      return;
    }
    printLog("receive service: $data");

    /* ensure login */
    var res = <String, dynamic>{"action": data["action"], "hashCode": data["hashCode"]};
    try {
      await BackgroundLoginController.login(autologin: true, username: null, password: null);

      final BackgroundServiceAction action = BackgroundServiceAction.values.byName(data["action"]);
      switch (action) {
        case BackgroundServiceAction.logout:
          await BackgroundLoginController.logout();
          res["data"] = true;
          break;
        case BackgroundServiceAction.fetchTodoListAll:
          await BackgroundTodoController.fetchTodoListAll();
          break;
        case BackgroundServiceAction.fetchTodoList:
          var courseIdList = List<String>.from(data["courseIdList"]);
          await BackgroundTodoController.fetchTodoList(courseIdList);
          break;
        case BackgroundServiceAction.fetchNotificationList:
          await BackgroundNotificationController.updateNotificationList(data["enableNotify"]);
          break;
        case BackgroundServiceAction.download:
          var downloadInformation = DownloadInformation.fromJson(Map<String, String>.from(data["downloadInformation"]));
          await BackgroundDownloadController.download(downloadInformation);
          break;
        case BackgroundServiceAction.update:
          break;
      }
    } catch (e, stacktrace) {
      BackgroundTodoController.refreshLock.clear();
      await ExceptionController.onExpcetion(stacktrace.toString(), false);
      res.addAll({"error": e.toString(), "stacktrace": stacktrace.toString()});
    }

    printLog("send service: ${res["data"].toString()}");
    service.sendData(res);
  });

  if (StorageController.loadLastNotiSyncTime() != DateTime(2000) &&
      DateTime.now().difference(StorageController.loadLastNotiSyncTime()) >= const Duration(minutes: 5)) {
    await BackgroundNotificationController.updateNotificationList(true);
  }

  Timer.periodic(
    const Duration(minutes: 3),
    (timer) async => timerBody(service),
  );
}

Future<void> timerBody(final FlutterBackgroundService service) async {
  try {
    await BackgroundNotificationController.updateNotificationList(true);
    final now = DateTime.now();
    final lastTodoSyncTime = StorageController.loadLastTodoSyncTime();
    if (now.difference(lastTodoSyncTime) >= const Duration(hours: 12)) {
      await BackgroundTodoController.fetchTodoListAll();
    }

    var res = <String, dynamic>{"action": BackgroundServiceAction.update.name};
    service.sendData(res);
  } catch (e, stacktrace) {
    BackgroundTodoController.refreshLock.clear();
    await ExceptionController.onExpcetion(stacktrace.toString(), false);
  }

  // var document = await StorageController.getDownloadDirectory();

  // await File(
  //         '$document/${DateFormat("MM-dd_HH:mm").format(StorageController.loadLastNotiSyncTime())} ${DateFormat("MM-dd_HH:mm").format(StorageController.loadLastTodoSyncTime())}')
  //     .writeAsString('0', mode: FileMode.append);
}
