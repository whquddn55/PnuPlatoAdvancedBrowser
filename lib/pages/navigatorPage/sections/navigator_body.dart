import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  late final List<Widget> _navigatedPages;
  final _navigatorKeyList = List.generate(3, (index) => GlobalKey<NavigatorState>());
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _navigatedPages = _pages.map(
      (page) {
        int index = _pages.indexOf(page);
        return CustomNavigator(
          page: page,
          navigatorKey: _navigatorKeyList[index],
        );
      },
    ).toList();
  }

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
            children: _navigatedPages,
          ),
          bottomNavigationBar: TabBar(
            onTap: (index) => setState(() {
              _currentIndex = index;
            }),
            indicator: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Get.theme.colorScheme.secondary,
                  width: 3.0,
                ),
              ),
            ),
            tabs: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Tab(child: Column(children: const [Icon(Icons.home), Text('플라토')])),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Tab(child: Column(children: const [Icon(Icons.calendar_today_outlined), Text('캘린더')])),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Tab(child: Column(children: const [Icon(Icons.email), Text('쪽지')])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
