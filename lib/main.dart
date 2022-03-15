import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/hive_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notice_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/LandingPage/landing_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/navigator_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveController.initialize();
  await AppSettingController.initilize();
  await NotificationController.initilize();

  await initializeDateFormatting();
  await Firebase.initializeApp();
  Get.put(LoginController());
  Get.put(RouteController());
  Get.put(DownloadController());
  Get.put(NoticeController());
  Get.put(TodoController());
  await TodoController.to.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PnuPlatoAdvancedBrowser',
      scrollBehavior: _CustomScrollBehavior(),
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        brightness: Brightness.light,
        fontFamily: 'DoHyeonRegular',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.0,
          toolbarHeight: 50,
        ),
      ),
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(primaryColor: Colors.lightBlue, brightness: Brightness.dark, fontFamily: 'DoHyeonRegular'),
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
