import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/LandingPage/sections/bottom_typography.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _animationFinished = false;

  @override
  void initState() {
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
                        var res = await showDialog(
                          context: context,
                          useRootNavigator: true,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text("[학번] 의 정보가 서버에 저장됩니다. 알림 및 버그리포트 기능을 위해서 사용되며, 개인을 특정하거나 판별할 수 있는 다른 정보는 일체 저장되지 않습니다."),
                              actions: [
                                TextButton(
                                  child: const Text("취소"),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                                TextButton(
                                  child: const Text("동의"),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        if (res == true) {
                          AppSettingController.to.isFirst = false;
                        } else {
                          showDialog(
                            context: context,
                            useRootNavigator: true,
                            builder: (context) {
                              return const AlertDialog(content: Text("정보제공의 동의하지 않을 경우 앱 사용이 불가능합니다."));
                            },
                          );
                        }
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
