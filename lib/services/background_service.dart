import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';

enum BackgroundServiceAction { login, logout, fetchTodoList, fetchTodoListAll, none }

/* APP 부분 */
abstract class BackgroundService {
  static final FlutterBackgroundService service = FlutterBackgroundService();
  static Completer<Map<String, dynamic>> loginCompleter = Completer<Map<String, dynamic>>();
  static Completer<bool> logoutCompleter = Completer<bool>();

  static Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: _onStart,
        // auto start service
        autoStart: true,
        isForegroundMode: true,
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

    service.onDataReceived.listen((data) {
      if (data == null) {
        return;
      }

      BackgroundServiceAction action = BackgroundServiceAction.none;
      for (var a in BackgroundServiceAction.values) {
        if (a.toString() == data["action"]) {
          action = a;
        }
      }

      switch (action) {
        case BackgroundServiceAction.login:
          loginCompleter.complete(data["data"]);
          break;
        case BackgroundServiceAction.logout:
          logoutCompleter.complete(data["data"]);
          break;

        case BackgroundServiceAction.fetchTodoListAll:
          break;

        case BackgroundServiceAction.none:
          assert(false);
          break;
      }
    });
  }

  static void sendData(final BackgroundServiceAction action, {Map<String, dynamic>? data}) {
    switch (action) {
      case BackgroundServiceAction.login:
        loginCompleter = Completer();
        break;
      case BackgroundServiceAction.logout:
        logoutCompleter = Completer();
        break;
    }

    if (data == null) {
      service.sendData({"action": action.toString()});
    } else {
      service.sendData({"action": action.toString(), ...data});
    }
  }
}

/* 서비스 부분 */
void _onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void _onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((data) async {
    if (data == null) {
      return;
    }

    BackgroundServiceAction action = BackgroundServiceAction.none;
    for (var a in BackgroundServiceAction.values) {
      if (a.toString() == data["action"]) {
        action = a;
      }
    }

    print("[DEBUG] $data");

    var res = <String, dynamic>{"action": data["action"]};

    switch (action) {
      case BackgroundServiceAction.login:
        res["data"] = await BackgroundLoginController.login(autologin: data["autologin"], username: data["username"], password: data["password"]);
        service.sendData(res);
        break;
      case BackgroundServiceAction.logout:
        res["data"] = await BackgroundLoginController.logout();
        service.sendData(res);
        break;
      // case BackgroundServiceAction.fetchTodoList:
      //   var courseId = data["courseId"] as String;
      //   await _TodoController.fetchTodoListByCourseId(courseId);
      //   service.sendData({"todoList": _TodoController.todoList});
      //   break;

      // case BackgroundServiceAction.fetchTodoListAll:
      //   await _TodoController.fetchTodoListAll();
      //   service.sendData({"todoList": _TodoController.todoList});
      //   break;

      case BackgroundServiceAction.none:
        assert(false);
        break;
    }
  });
}
