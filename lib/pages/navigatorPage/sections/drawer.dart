import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/courseController.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Builder(builder: (context) {
        return GetBuilder<UserDataController>(
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
                          child: const Text('로그아웃'),
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
                ListTile(onTap: () async {
                  var t = [10, 11, 20, 21];
                  for (int i = 2014; i <= 2021; ++i) {
                    for (int j in t) {
                      var list = await Get.find<CourseController>().getCourseList(i, j);
                      if (list != null) {
                        for (var course in list) {
                          await Get.find<CourseController>().updateCourseSpecification(course);
                        }
                      }
                    }
                  }
                })
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
                    Get.toNamed('/login');
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
        );
      }),
    );
  }
}
