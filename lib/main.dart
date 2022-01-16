import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/screens/landingScreen.dart';
import 'package:pnu_plato_advanced_browser/screens/loginPage/loginPage.dart';
import 'package:pnu_plato_advanced_browser/screens/loginPage/sections/findInformationPage.dart';
import 'package:pnu_plato_advanced_browser/screens/navigatorScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(UserDataController());
    return GetMaterialApp(
      title: 'PnuPlatoAdvancedBrowser',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LandingScreen(), transition: Transition.cupertino),
        GetPage(name: '/navigator', page: () => const NavigatorScreen(), transition: Transition.cupertino),
        GetPage(name: '/login', page: () => const LoginPage(), transition: Transition.cupertino),
        GetPage(name: '/login/findInformation/:target', page: () => FindInformationPage(), transition: Transition.cupertino)
      ]
    );
  }
}