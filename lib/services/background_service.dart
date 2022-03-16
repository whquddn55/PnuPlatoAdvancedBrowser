import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_notification_controller.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_todo_controller.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/bakcground_download_controller.dart';

enum BackgroundServiceAction { logout, fetchTodoList, fetchNotificationList, download }

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
        case BackgroundServiceAction.logout:
          _completerMap[data["hashCode"]]?.complete(data);
          break;
        case BackgroundServiceAction.fetchTodoList:
          _completerMap[data["hashCode"]]?.complete(data);

          break;
        case BackgroundServiceAction.fetchNotificationList:
          _completerMap[data["hashCode"]]?.complete(data);
          break;
        case BackgroundServiceAction.download:
          _completerMap[data["hashCode"]]?.complete(data);
          break;
      }
      _completerMap.remove(data["hashCode"]);
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

  if (Platform.isAndroid) {
    PathProviderAndroid.registerWith();
  }
  if (Platform.isIOS) {
    PathProviderIOS.registerWith();
  }
  await StorageController.initialize();

  /* ensure login */
  await BackgroundLoginController.login(autologin: true, username: null, password: null);

  final service = FlutterBackgroundService();
  service.onDataReceived.listen((data) async {
    if (data == null) {
      return;
    }
    printLog("receive service: $data");

    /* ensure login */
    await BackgroundLoginController.login(autologin: true, username: null, password: null);

    var res = <String, dynamic>{"action": data["action"], "hashCode": data["hashCode"]};
    final BackgroundServiceAction action = BackgroundServiceAction.values.byName(data["action"]);
    switch (action) {
      case BackgroundServiceAction.logout:
        res["data"] = await BackgroundLoginController.logout();
        break;
      case BackgroundServiceAction.fetchTodoList:
        var courseIdList = List<String>.from(data["courseIdList"]);
        await BackgroundTodoController.fetchTodoList(courseIdList);
        break;
      case BackgroundServiceAction.fetchNotificationList:
        await BackgroundNotificationController.updateNotificationList();
        break;
      case BackgroundServiceAction.download:
        var downloadInformation = DownloadInformation.fromJson(Map<String, String>.from(data["downloadInformation"]));
        await BackgroundDownloadController.download(downloadInformation);
        break;
    }

    service.sendData(res);

    printLog("send service: ${res["data"].toString()}");
  });

  var lastFetchTodoTime = await StorageController.loadLastSyncTime();
  if (DateTime.now().difference(lastFetchTodoTime).inSeconds >= 300) {
    await timerBody();
  }

  Timer.periodic(
    const Duration(minutes: 3),
    (timer) async => timerBody(),
  );
}

Future<void> timerBody() async {
  await BackgroundNotificationController.updateNotificationList();
  //var document = await getApplicationSupportDirectory();

  // await File(
  //         '/storage/emulated/0/Android/data/com.thuthi.PnuPlatoAdvancedBrowser.pnu_plato_advanced_browser/files/${DateFormat("MM-dd_HH:mm").format(DateTime.now())}.txt')
  //     .writeAsString(res.data, mode: FileMode.append);

  await StorageController.storeLastSyncTime(DateTime.now());
}
