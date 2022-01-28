import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/loginPage/login_page.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

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
                    Get.find<RouteController>().showBottomNavBar = false;
                    await showModalBottomSheet(context: context, builder: (context) => _logoutBottomSheet(context));
                    Get.find<RouteController>().showBottomNavBar = true;
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
                onTap: () {
                  Get.find<AppSettingController>().toggleTheme();
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

  _logoutBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        runSpacing: 20,
        children: [
          Text('로그아웃 시 모든 세팅이 초기화 됩니다.', style: Get.textTheme.bodyText1),
          const Divider(height: 0, thickness: 1.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('로그아웃'),
                onPressed: () async {
                  var pd = ProgressDialog(context: context);
                  pd.show(max: 1, msg: '로그아웃 중입니다...', progressBgColor: Colors.transparent, barrierDismissible: true);
                  await Get.find<UserDataController>().logout();
                  pd.close();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(primary: Colors.black),
              ),
              TextButton.icon(
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(primary: Get.textTheme.bodyText1!.color),
              )
            ],
          )
        ],
      ),
    );
  }
}
