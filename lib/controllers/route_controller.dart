import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/calendar_page.dart';
import 'package:pnu_plato_advanced_browser/pages/chat_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/plato_page.dart';

class RouteController extends GetxController {
  final _pages = const [PlatoPage(), CalendarPage(), ChatPage()];
  late final _navigatedPages;
  final _navigatorKeyList = List.generate(3, (index) => GlobalKey<NavigatorState>());
  int _currentIndex = 0;
  bool _showBottomNavBar = true;

  RouteController() {
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

  List<Widget> get pages => _navigatedPages;

  int get currentIndex => _currentIndex;
  set currentIndex(int index) {
    _currentIndex = index;
    update();
  }

  bool get showBottomNavBar => _showBottomNavBar;
  set showBottomNavBar(bool status) {
    _showBottomNavBar = status;
    update();
  }

  void toggleBottomNavBar() => _showBottomNavBar = !_showBottomNavBar;

  Future<bool> maybePop() async {
    return _navigatorKeyList[_currentIndex].currentState!.maybePop();
  }
}

class CustomNavigator extends StatefulWidget {
  final Widget page;
  final Key navigatorKey;
  const CustomNavigator({Key? key, required this.page, required this.navigatorKey}) : super(key: key);

  @override
  _CustomNavigatorState createState() => _CustomNavigatorState();
}

class _CustomNavigatorState extends State<CustomNavigator> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (context) => widget.page),
    );
  }
}
