import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page1.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page2.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page3.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page4.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/landing_page5.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  final _pages = const [
    LandingPage1(),
    LandingPage2(),
    LandingPage3(),
    LandingPage4(),
    LandingPage5(),
  ];
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
                    children: _pages,
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
    if (_currentPage == _pages.length - 1) {
      result.add(TextButton(
        child: const Text("PPAB시작"),
        onPressed: _onDone,
      ));
    } else {
      result.add(
        Opacity(
          opacity: _currentPage == 0 ? 0 : 1,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: _currentPage == 0
                ? null
                : () => setState(() {
                      _currentPage = _currentPage - 1;
                      _pageController.jumpToPage(_currentPage);
                    }),
          ),
        ),
      );
      for (int i = 0; i < _pages.length; ++i) {
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
      result.add(
        IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.blue),
          onPressed: () => setState(() {
            _currentPage = _currentPage + 1;
            _pageController.jumpToPage(_currentPage);
          }),
        ),
      );
    }

    return result;
  }

  void _onDone() async {
    var res = await showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("※PPAB는 공식적으로 한국어만 지원합니다.", style: TextStyle(fontSize: 11, color: Colors.redAccent)),
              Text("※PPAB는 공식적으로 학부 강의만 지원합니다.\n제가 대학원을 가면...(안가요)", style: TextStyle(fontSize: 11, color: Colors.redAccent)),
              Text("※PPAB는 부산대학교 공식앱이 아닙니다. 따라서, 정보가 정확하지 않습니다.", style: TextStyle(fontSize: 11, color: Colors.redAccent)),
              Text("※PPAB는 버그리포트 위해 학번 정보를 수집합니다. 학번 이외의 비밀번호, 이름등의 정보는 일체 사용되지 않습니다.", style: TextStyle(fontSize: 11, color: Colors.redAccent)),
            ],
          ),
          content: const Text("주의사항을 다 확인하셨나요?", style: TextStyle(fontSize: 12)),
          actions: [
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text("확인"),
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
    }
  }
}
