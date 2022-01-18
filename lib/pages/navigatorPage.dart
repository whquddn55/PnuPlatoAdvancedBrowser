import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage.dart';
import 'package:pnu_plato_advanced_browser/pages/chatPage.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/platoPage.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentIndex = 0;
  final _pages = [const PlatoPage(), const CalendarPage(), const ChatPage()];
  final _loginFuture = Get.find<UserDataController>().login();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      drawer: _renderDrawer(),
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
          if (snapshot.hasData) {
            return _pages[_currentIndex];
          }
          return const LoadingPage(msg: '로그인 중...');
        }
      ),
    );
  }

  Widget _renderDrawer() {
    return Drawer(
      child: Builder(
          builder: (context) {
            return GetBuilder<UserDataController>(
              builder: (controller) {
                if (controller.loginStatus) {
                  return ListView(
                      children: [
                        UserAccountsDrawerHeader(
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: NetworkImage(controller.imgUrl),
                          ),
                          accountEmail: Text(controller.department),
                          accountName: Text(controller.name),
                          decoration: BoxDecoration(
                              color: Get.theme.primaryColor
                          ),
                        ),
                        ListTile(
                          title: Text('동기화 시간: ${controller.lastSyncTime}'),
                          dense: true,
                        ),
                        const Divider(height: 0),
                        ListTile(
                            trailing: const Icon(Icons.logout),
                            title: const Text('로그아웃'),
                            onTap: () {
                              Get.defaultDialog(
                                title: '로그아웃',
                                middleText: '로그아웃 시 모든 세팅이 초기화 됩니다.',
                                cancel: TextButton(
                                  child: Text('취소', style: TextStyle(color: Get.theme.disabledColor)),
                                  onPressed: () {
                                      Get.back();
                                  },
                                ),
                                confirm: TextButton(
                                  child: Text('로그아웃'),
                                  onPressed: () async {
                                    Get.back();
                                    var pd = ProgressDialog(context: context);
                                    pd.show(max: 1, msg: '로그아웃 중입니다...', progressBgColor: Colors.transparent);
                                    bool res = await controller.logout();
                                    pd.close();
                                    if (res) {
                                      Get.offAndToNamed('/');
                                    }
                                  },
                                ),
                              );
                            }
                        ),
                        const Divider(height: 0),
                        ListTile(
                            trailing: const Icon(Icons.settings),
                            title: const Text('세팅'),
                            onTap: () {
                              /* TODO: 세팅 화면으로 이동 */
                              //Get.toNamed('/setting');
                            }
                        ),
                        const Divider(height: 0),
                        ListTile(
                            trailing: const Icon(Icons.bug_report_outlined),
                            title: const Text('버그리포트'),
                            onTap: () {
                              showBugReport('123');
                            }
                        ),
                        ListTile(
                          onTap: () {
                            Get.changeThemeMode(ThemeMode.light);
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
                                controller.imgUrl),
                          ),
                          accountEmail: Text(controller.department),
                          accountName: Text(controller.name),
                          decoration: BoxDecoration(
                              color: Get.theme.disabledColor
                          ),
                        ),
                        ListTile(
                          trailing: const Icon(Icons.login),
                          title: const Text('로그인'),
                          onTap: () {
                            Get.toNamed('/login');
                          },
                        ),
                        const Divider(height: 0),
                        ListTile(
                            trailing: const Icon(Icons.bug_report_outlined),
                            title: const Text('버그리포트'),
                            onTap: () {
                              showBugReport('123');
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
