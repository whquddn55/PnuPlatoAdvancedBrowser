import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/loginPage/login_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: GetBuilder<UserDataController>(
        builder: (controller) {
          if (controller.loginStatus) {
            return ListView(children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(controller.imgUrl),
                ),
                accountEmail: Text(controller.department),
                accountName: Text(controller.name),
                decoration: BoxDecoration(color: Get.theme.primaryColor),
              ),
              ListTile(
                title: Text('동기화 시간: ${controller.lastSyncTime}'),
                dense: true,
              ),
              const Divider(height: 0),
              ListTile(
                  trailing: const Icon(Icons.logout),
                  title: const Text('로그아웃'),
                  onTap: () async {
                    var message = await showModalActionSheet(
                      context: context,
                      title: '로그아웃',
                      message: '로그아웃 시 모든 세팅이 초기화 됩니다.',
                      actions: [
                        const SheetAction(icon: Icons.logout, label: '로그아웃', key: true, isDefaultAction: true),
                        const SheetAction(icon: Icons.cancel, label: '취소', key: false, isDestructiveAction: true),
                      ],
                    );
                    if (message == true) {
                      late final BuildContext dialogContext;
                      showDialog(
                        context: context,
                        builder: (context) {
                          dialogContext = context;
                          return AlertDialog(
                              content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              CircularProgressIndicator(),
                              Text('로그아웃 중입니다...'),
                            ],
                          ));
                        },
                      );
                      await controller.logout();
                      Navigator.pop(dialogContext);
                    }
                  }),
              const Divider(height: 0),
              ListTile(
                  trailing: const Icon(Icons.settings),
                  title: const Text('세팅'),
                  onTap: () {
                    /* TODO: 세팅 화면으로 이동 */
                    //Get.toNamed('/setting');
                  }),
              const Divider(height: 0),
              ListTile(
                  trailing: const Icon(Icons.bug_report_outlined),
                  title: const Text('버그리포트'),
                  onTap: () {
                    showBugReport('123');
                  }),
              ListTile(
                onTap: () async {
                  if (Get.theme.brightness == Brightness.dark) {
                    Get.changeThemeMode(ThemeMode.light);
                  } else {
                    Get.changeThemeMode(ThemeMode.dark);
                  }
                },
              ),
              ListTile(
                onTap: () async {
                  var t = [10, 11, 20, 21];
                  for (int i = 2014; i <= 2021; ++i) {
                    for (int j in t) {
                      var list = await Get.find<CourseController>().fetchCourseList(i, j);
                      if (list != null) {
                        for (var course in list) {
                          await Get.find<CourseController>().updateCourseSpecification(course);
                        }
                      }
                    }
                  }
                },
              )
            ]);
          } else {
            return ListView(children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(controller.imgUrl),
                ),
                accountEmail: Text(controller.department),
                accountName: Text(controller.name),
                decoration: BoxDecoration(color: Get.theme.disabledColor),
              ),
              ListTile(
                trailing: const Icon(Icons.login),
                title: const Text('로그인'),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const LoginPage()));
                },
              ),
              const Divider(height: 0),
              ListTile(
                  trailing: const Icon(Icons.bug_report_outlined),
                  title: const Text('버그리포트'),
                  onTap: () {
                    showBugReport('123');
                  }),
            ]);
          }
        },
      ),
    );
  }
}
