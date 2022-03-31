import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/firebase_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/LandingPage/landing_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/navigator_page.dart';

void main() async {
  FlutterError.onError = (details) {
    ExceptionController.onExpcetion(details.exception.toString() + "\n" + (details.stack?.toString() ?? ""), true);
  };
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await StorageController.initialize();

      await initializeDateFormatting();
      await Firebase.initializeApp();
      Get.put(LoginController());
      Get.put(RouteController());
      Get.put(FirebaseController());
      Get.put(TodoController());
      Get.put(AppSettingController());
      AppSettingController.to.initialize();
      TodoController.to.initialize();
      await NotificationController.initialize();

      runApp(const MyApp());
    },
    (error, stacktrace) => ExceptionController.onExpcetion(error.toString() + "\n" + (stacktrace.toString()), true),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().actionStream.listen((event) => NotificationController.onNotificationTap(event));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      title: 'PnuPlatoAdvancedBrowser',
      scrollBehavior: _CustomScrollBehavior(),
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        brightness: Brightness.light,
        fontFamily: 'NaNumSquearRound',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.0,
          toolbarHeight: 40,
          titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      themeMode: ThemeMode.light,
      home: GetBuilder<AppSettingController>(
        builder: (controller) {
          return controller.isFirst ? const LandingPage() : const NavigatorPage();
        },
      ),
    );
  }
}

class _CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
