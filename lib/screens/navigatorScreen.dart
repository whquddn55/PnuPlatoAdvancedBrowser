import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/screens/calendarScreen.dart';
import 'package:pnu_plato_advanced_browser/screens/chatScreen.dart';
import 'package:pnu_plato_advanced_browser/screens/platoScreen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _currentIndex = 0;
  final _pages = [PlatoScreen(), CalendarScreen(), ChatScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/defaultAvatar.png",),
              ),
              accountEmail: Text('test@gmail.com'),
              accountName: Text('test'),
            ),
            /*
              로그인 상태 : 로그아웃, 세팅, 버그리포트
              로그아웃 상태 : 로그인
            */
            ListTile(
                title: Text('item1')
            ),
            ListTile(
                title: Text('item2')
            ),
            ListTile(
                title: Text('item3')
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
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
    );
  }
}
