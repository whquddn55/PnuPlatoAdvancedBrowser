import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notice_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/LandingPage/landing_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/navigator_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageController.initialize();
  await AppSettingController.initilize();

  await initializeDateFormatting();
  await Firebase.initializeApp();
  Get.put(LoginController());
  Get.put(RouteController());
  Get.put(NoticeController());
  Get.put(TodoController());
  await TodoController.to.initialize();
  await NotificationController.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().actionStream.listen((event) {
      final String type = event.payload?["type"] ?? "";
      if (type == "todo") {
        RouteController.to.currentIndex = 1;
      } else if (type == "file") {
        RouteController.to.currentIndex = 3;
      } else if (type == "notification") {
        RouteController.to.currentIndex = 4;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
        ),
      ),
      themeMode: ThemeMode.light,
      //darkTheme: ThemeData(primaryColor: Colors.lightBlue, brightness: Brightness.dark, fontFamily: 'DoHyeonRegular'),
      home: AppSettingController.isFirst ? const LandingPage() : const NavigatorPage(),
    );
  }
}

class _CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
