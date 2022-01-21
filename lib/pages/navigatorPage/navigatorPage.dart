import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/calendarPage.dart';
import 'package:pnu_plato_advanced_browser/pages/chatPage.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/sections/drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/platoPage.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentIndex = 0;
  final _pages = [const PlatoPage(), const CalendarPage(), const ChatPage()];
  final _navigatorKeyList = <GlobalKey<NavigatorState>>[GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>()];
  final _loginFuture = Get.find<UserDataController>().login();

  List<Widget> _drawPage() {
    return List.generate(_pages.length, (index) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        drawer: const MainDrawer(),
        body: FutureBuilder(
            future: _loginFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _pages[index];
              }
              return const LoadingPage(msg: '로그인 중...');
            }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !(await _navigatorKeyList[_currentIndex].currentState!.maybePop());
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Get.theme.primaryColor,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '플라토',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: '캘린더',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: '쪽지',
            ),
          ],
        ),
        body: FutureBuilder(
            future: _loginFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return IndexedStack(
                  index: _currentIndex,
                  children: _pages.map((page) {
                    int index = _pages.indexOf(page);
                    return Navigator(
                      key: _navigatorKeyList[index],
                      onGenerateRoute: (_) {
                        return MaterialPageRoute(builder: (context) => page);
                      },
                    );
                  }).toList(),
                );
              }
              return const LoadingPage(msg: '로그인 중...');
            }),
      ),
    );
  }
}
