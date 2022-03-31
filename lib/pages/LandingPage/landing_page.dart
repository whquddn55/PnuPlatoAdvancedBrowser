import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page1.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page2.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page3.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page4.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page5.dart';

class LandingPage extends StatefulWidget {
  static const int pageLength = 6;
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: const [
                      LandingPage1(),
                      LandingPage2(),
                      LandingPage3(),
                      LandingPage4(),
                      LandingPage5(),
                      LandingPage1(),
                    ],
                    onPageChanged: (index) => setState(() => _currentPage = index),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _renderBottom(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderBottom() {
    final result = <Widget>[];
    if (_currentPage == LandingPage.pageLength - 1) {
      result.add(TextButton(
        child: const Text("PPAB시작"),
        onPressed: _onDone,
      ));
    } else {
      for (int i = 0; i < LandingPage.pageLength; ++i) {
        result.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 2),
            color: _currentPage == i ? Colors.blue : Colors.white,
          ),
          height: 10,
          width: 10,
        ));
        result.add(const SizedBox(width: 4));
      }
    }

    return result;
  }

  void _onDone() async {
    var res = await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return AlertDialog(
          content: const Text("[학번] 의 정보가 서버에 저장됩니다. 다른 정보는 일체 저장되지 않습니다.", style: TextStyle(fontSize: 12)),
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
  }
}
