import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/pages/LandingPage/sections/bottomTypography.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/platoPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _animationFinished = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _animationFinished = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const Image(
          image: AssetImage('assets/splash.gif'),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: _animationFinished ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BottomTypography(),
                  const SizedBox(height: 200),
                  Center(
                    child: ElevatedButton(
                      child: const Text('PPAB 시작하기'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 50),
                      ),
                      onPressed: () async {
                        (await SharedPreferences.getInstance()).setBool('isFirst', false);
                        Get.offNamed('/navigator');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
