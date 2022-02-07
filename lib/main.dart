import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pnu_plato_advanced_browser/controllers/activity_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/LandingPage/landing_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/navigator_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp();
  Get.put(UserDataController());
  Get.put(CourseController());
  Get.put(ActivityController());
  Get.put(RouteController());
  Get.put(DownloadController());
  await AppSettingController.initiate();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PnuPlatoAdvancedBrowser',
      theme: ThemeData(primaryColor: Colors.lightBlue, brightness: Brightness.light, fontFamily: 'DoHyeonRegular'),
      darkTheme: ThemeData(primaryColor: Colors.lightBlue, brightness: Brightness.dark, fontFamily: 'DoHyeonRegular'),
      themeMode: AppSettingController.themeMode,
      home: AppSettingController.isFirst ? const LandingPage() : const NavigatorPage(),
    );
  }
}
