import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notice_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/LandingPage/landing_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/navigator_page.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp();
  Get.put(LoginController());
  Get.put(RouteController());
  Get.put(DownloadController());
  Get.put(NoticeController());
  Get.put(TodoController());
  await AppSettingController.initiate();
  await Get.find<TodoController>().initiate();

  await BackgroundService.initializeService();

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
      darkTheme: ThemeData(primaryColor: Colors.lightBlue, brightness: Brightness.dark, fontFamily: 'DoHyeonRegular'),
      themeMode: AppSettingController.themeMode,
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
