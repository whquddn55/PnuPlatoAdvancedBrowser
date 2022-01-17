import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage.dart';
import 'package:pnu_plato_advanced_browser/pages/loginPage/loginPage.dart';
import 'package:pnu_plato_advanced_browser/pages/loginPage/sections/findInformationPage.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(UserDataController());

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
          primarySwatch: Colors.lightBlue,
            brightness: Brightness.dark,
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () {
            return FutureBuilder(
              future: _getIsFirst(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return const LandingPage();
                  }
                    return const NavigatorPage();
                }
                return Scaffold(body: Container());
              }
            );
          }, transition: Transition.cupertino),
          GetPage(name: '/navigator', page: () => const NavigatorPage(), transition: Transition.cupertino),
          GetPage(name: '/login', page: () => const LoginPage(), transition: Transition.cupertino),
          GetPage(name: '/login/findInformation/:target', page: () => FindInformationPage(), transition: Transition.cupertino)
        ]
    );
  }
}