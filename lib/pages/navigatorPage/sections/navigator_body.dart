import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/calendar_page.dart';
import 'package:pnu_plato_advanced_browser/pages/chat_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/sections/custom_navigator.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/plato_page.dart';

class NavigatorBody extends StatefulWidget {
  const NavigatorBody({Key? key}) : super(key: key);

  @override
  _NavigatorBodyState createState() => _NavigatorBodyState();
}

class _NavigatorBodyState extends State<NavigatorBody> {
  final _pages = [const PlatoPage(), const CalendarPage(), const ChatPage()];
  final _navigatorKeyList = List.generate(3, (index) => GlobalKey<NavigatorState>());
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !(await _navigatorKeyList[_currentIndex].currentState!.maybePop());
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            children: _pages.map((page) => CustomNavigator(page: page)).toList(),
          ),
          bottomNavigationBar: TabBar(
            isScrollable: false,
            indicatorPadding: const EdgeInsets.only(bottom: 74),
            automaticIndicatorColorAdjustment: true,
            onTap: (index) => setState(() {
              _currentIndex = index;
            }),
            tabs: const [
              Tab(
                icon: Icon(
                  Icons.home,
                ),
                text: '플라토',
              ),
              Tab(
                icon: Icon(
                  Icons.calendar_today,
                ),
                text: '캘린더',
              ),
              Tab(
                icon: Icon(
                  Icons.email,
                ),
                text: '쪽지',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
