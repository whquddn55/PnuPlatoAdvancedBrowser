import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/notice_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';
import 'package:pnu_plato_advanced_browser/pages/bugReportPage/bug_report_page.dart';
import 'package:pnu_plato_advanced_browser/pages/loginPage/login_page.dart';
import 'package:pnu_plato_advanced_browser/pages/noticeListPage/notice_list_page.dart';
import 'package:pnu_plato_advanced_browser/pages/settingPage/setting_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: GetBuilder<LoginController>(
        builder: (controller) {
          if (controller.loginInformation.loginStatus) {
            return _renderAthorizedListView(context, controller);
          } else {
            return _renderUnathorizedListView(context, controller);
          }
        },
      ),
    );
  }

  Widget _renderAthorizedListView(final BuildContext context, final LoginController controller) {
    final String studentId = controller.loginInformation.studentId.toString();
    return ListView(children: [
      UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(controller.loginInformation.imgUrl, errorListener: () {}),
        ),
        accountEmail: Text(controller.loginInformation.department),
        accountName: Text(controller.loginInformation.name),
      ),
      ListTile(
          trailing: const Icon(Icons.logout),
          title: const Text('로그아웃'),
          onTap: () async {
            await showModalBottomSheet(context: context, useRootNavigator: true, builder: (context) => _renderLogoutBottomSheet(context));
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
        trailing: GetBuilder<NoticeController>(
          builder: (controller) {
            int unread = controller.unreadCount();
            return Badge(child: const Icon(Icons.announcement), badgeContent: Text(unread.toString()), showBadge: unread != 0);
          },
        ),
        title: const Text('PPAB 공지사항'),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const NoticeListPage()));
        },
      ),
      const Divider(height: 0),
      ListTile(
        trailing: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("users").doc(studentId).snapshots(),
          builder: (context, snapshot) {
            int unread = 0;
            if (snapshot.connectionState == ConnectionState.active) {
              unread = snapshot.data!["unread"];
            }
            return Badge(child: const Icon(Icons.bug_report_outlined), badgeContent: Text(unread.toString()), showBadge: unread != 0);
          },
        ),
        title: const Text('버그리포트'),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => BugReportPage(studentId, false)));
        },
      ),

      /* Debug 용 */
      // const Divider(height: 0),
      // ListTile(
      //     trailing: const Icon(Icons.settings),
      //     title: const Text('세팅2'),
      //     onTap: () {
      //       Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const AdminBugReportPage()));
      //     }),
      // const Divider(height: 0),
      // ListTile(
      //     trailing: const Icon(Icons.settings),
      //     title: const Text('디버그버튼'),
      //     onTap: () async {
      //       // await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
      //       var tdlist = TodoController.to.todoList;
      //       for (var todo in tdlist) {
      //         if (todo.id == "1319094") {
      //           tdlist.remove(todo);
      //           tdlist.add(ZoomTodo(
      //             index: 1000,
      //             id: "1319094",
      //             title: "ㅎㅇㅎㅇ",
      //             courseId: "119197",
      //             dueDate: DateTime.now().add(Duration(seconds: 5)),
      //             availability: true,
      //             iconUrl: "",
      //             status: TodoStatus.undone,
      //             userDefined: false,
      //             checked: false,
      //           ));
      //           break;
      //         }
      //       }
      //       StorageController.storeTodoList(tdlist);
      //       TodoController.to.updateTodoList();
      //       //TodoController.to.progress.value = !TodoController.to.progress.value;
      //       //StorageController.storeLoginInformation(LoginInformation(loginStatus: true));
      //       // StorageController.storeNotificationList([]);
      //       // NotificationController.fetchNotificationList();
      //     }),
    ]);
  }

  Widget _renderUnathorizedListView(final BuildContext context, final LoginController controller) {
    return ListView(children: [
      UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(controller.loginInformation.imgUrl, errorListener: () {}),
        ),
        accountEmail: Text(controller.loginInformation.department),
        accountName: Text(controller.loginInformation.name),
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

  Widget _renderLogoutBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        runSpacing: 20,
        children: [
          Text('로그아웃 시 모든 세팅이 초기화 됩니다.', style: Get.textTheme.bodyText1),
          const Divider(height: 0, thickness: 1.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                child: Row(children: const [Icon(Icons.logout), Text('로그아웃')]),
                onPressed: () async {
                  Navigator.pop(context);
                  var dialogContext = await showProgressDialog(context, "로그아웃 중입니다...");
                  await Get.find<LoginController>().logout();
                  closeProgressDialog(dialogContext);
                },
                style: TextButton.styleFrom(primary: Get.textTheme.bodyText1!.color),
              ),
              TextButton(
                child: Row(
                  children: const [Icon(Icons.cancel_outlined), Text('취소')],
                ),
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
