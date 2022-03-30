import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/LandingPage/sections/bottom_typography.dart';
import 'package:introduction_screen/introduction_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome To PPAB",
          body: "body",
        ),
        PageViewModel(
          title: "Welcome To PPAB",
          body: "body",
        ),
        PageViewModel(
          title: "Welcome To PPAB",
          body: "body",
        ),
      ],
      done: const Text("done"),
      onDone: () async {
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
      next: const Icon(Icons.arrow_forward),
    );
  }
}
