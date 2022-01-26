import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pnu_plato_advanced_browser/controllers/activity_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/LandingPage/landing_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/navigator_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  Get.put(UserDataController());
  Get.put(AppSettingController());
  Get.put(CourseController());
  Get.put(ActivityController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _getIsFirst() async {
    return (await SharedPreferences.getInstance()).getBool('isFirst') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PnuPlatoAdvancedBrowser',
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
      home: FutureBuilder(
        future: _getIsFirst(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return const LandingPage();
            }
            return const NavigatorPage();
          }
          return Scaffold(body: Container());
        },
      ),
    );
  }
}
