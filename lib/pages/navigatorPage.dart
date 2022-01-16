import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage.dart';
import 'package:pnu_plato_advanced_browser/pages/chatPage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentIndex = 0;
  final _pages = [const PlatoPage(), const CalendarPage(), const ChatPage()];
  final _userDataController = Get.find<UserDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: _renderDrawer(),
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

  Widget _renderDrawer() {
    return Drawer(
      child: Builder(
          builder: (context) {
            return GetBuilder<UserDataController>(
              builder: (controller) {
                if (_userDataController.loginStatus) {
                  return ListView(
                      children: [
                        UserAccountsDrawerHeader(
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: NetworkImage(_userDataController.imgUrl),
                          ),
                          accountEmail: Text(_userDataController.department),
                          accountName: Text(_userDataController.name),
                        ),
                        ListTile(
                          title: Text('동기화 시간: ${_userDataController.lastSyncTime}'),
                          dense: true,
                        ),
                        ListTile(
                            trailing: const Icon(Icons.logout),
                            title: const Text('로그아웃'),
                            onTap: () {
                              Get.defaultDialog(
                                title: '로그아웃',
                                middleText: '로그아웃 시 모든 세팅이 초기화 됩니다.',
                                cancel: TextButton(
                                  child: Text('취소', style: TextStyle(color: Colors.grey)),
                                  onPressed: () {
                                      Get.back();
                                  },
                                ),
                                confirm: TextButton(
                                  child: Text('로그아웃'),
                                  onPressed: () async {
                                    var pd = ProgressDialog(context: context);
                                    Get.back();
                                    pd.show(max: 1, msg: '로그아웃 중입니다...', progressBgColor: Colors.transparent);
                                    await _userDataController.logout();
                                    pd.close();
                                  },
                                ),
                              );
                              /* TODO: 로그아웃 메시지박스 띄운 뒤 로그아웃 처리 */
                            }
                        ),
                        ListTile(
                            trailing: const Icon(Icons.settings),
                            title: const Text('세팅'),
                            onTap: () {
                              /* TODO: 세팅 화면으로 이동 */
                              //Get.toNamed('/setting');
                            }
                        ),
                        ListTile(
                            trailing: const Icon(Icons.bug_report_outlined),
                            title: const Text('버그리포트'),
                            onTap: () {
                              /* TODO: 버그리포트 메지박스 띄우기 */
                            }
                        )
                      ]
                  );
                }
                else {
                  return ListView(
                      children: [
                        UserAccountsDrawerHeader(
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: NetworkImage(
                                _userDataController.imgUrl),
                          ),
                          accountEmail: Text(_userDataController.department),
                          accountName: Text(_userDataController.name),
                          decoration: const BoxDecoration(
                              color: Colors.grey
                          ),
                        ),
                        ListTile(
                          trailing: const Icon(Icons.login),
                          title: const Text('로그인'),
                          onTap: () {
                            Get.toNamed('/login');
                          },
                        ),
                        ListTile(
                            trailing: const Icon(Icons.bug_report_outlined),
                            title: const Text('버그리포트'),
                            onTap: () {
                              /* TODO: 버그리포트 메지박스 띄우기 */
                            }
                        )
                      ]
                  );
                }
              },
            );
          }
      ),
    );
  }
}
