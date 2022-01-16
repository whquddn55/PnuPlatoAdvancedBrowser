import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/preferenceController.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage.dart';
import 'package:pnu_plato_advanced_browser/pages/loginPage/loginPage.dart';
import 'package:pnu_plato_advanced_browser/pages/loginPage/sections/findInformationPage.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(UserDataController());
  Get.put(await PreferenceController.instance());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'PnuPlatoAdvancedBrowser',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const LandingPage(), transition: Transition.cupertino),
          GetPage(name: '/navigator', page: () => const NavigatorPage(), transition: Transition.cupertino),
          GetPage(name: '/login', page: () => const LoginPage(), transition: Transition.cupertino),
          GetPage(name: '/login/findInformation/:target', page: () => FindInformationPage(), transition: Transition.cupertino)
        ]
    );
  }
}