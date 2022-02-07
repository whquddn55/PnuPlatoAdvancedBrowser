import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/bugReportPage/admin_bug_report_page.dart';
import 'package:pnu_plato_advanced_browser/pages/bugReportPage/bug_report_page.dart';
import 'package:pnu_plato_advanced_browser/pages/loginPage/login_page.dart';
import 'package:pnu_plato_advanced_browser/pages/settingPage/setting_page.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: GetBuilder<UserDataController>(
        builder: (controller) {
          if (controller.loginStatus) {
            final String studentId = "1234"; //controller.studentId.toString();
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
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const SettingPage()));
                  }),
              const Divider(height: 0),
              ListTile(
                  trailing: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection("chats").doc(studentId).snapshots(),
                      builder: (context, snapshot) {
                        Widget? badgeContent;
                        if (snapshot.connectionState == ConnectionState.active) {
                          badgeContent = Text(snapshot.data!["unread"].toString());
                        }
                        return Badge(child: const Icon(Icons.bug_report_outlined), badgeContent: badgeContent);
                      }),
                  title: const Text('버그리포트'),
                  onTap: () async {
                    var doc = await FirebaseFirestore.instance.collection("chats").doc(studentId).get();
                    if (doc.exists == false) {
                      var res = await showDialog(
                        context: context,
                        useRootNavigator: true,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text("버그리포트를 위해서 [학번] 의 정보가 서버로 전송됩니다. 채팅으로 피드백을 드리기 위해서만 사용됩니다."),
                            actions: [
                              TextButton(
                                child: const Text("취소"),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              TextButton(
                                child: const Text("동의"),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            ],
                          );
                        },
                      );
                      if (res) {
                        FirebaseFirestore.instance.collection("chats").doc(studentId).set({
                          "unread": 0,
                          "adminUnread": 0,
                          "time": Timestamp.now(),
                        });
                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => BugReportPage(studentId, false)));
                      }
                    } else {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => BugReportPage(studentId, false)));
                    }
                  }),
              const Divider(height: 0),
              ListTile(
                  trailing: const Icon(Icons.settings),
                  title: const Text('세팅2'),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const AdminBugReportPage()));
                  }),
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
                    var studentId = "123"; //Get.find<UserDataController>().studentId.toString();
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => BugReportPage(studentId, false)));
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
