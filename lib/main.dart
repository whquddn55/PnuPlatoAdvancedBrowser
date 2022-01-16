import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/screens/landingScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PnuPlatoAdvancedBrowser',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
      },
    );
  }
}