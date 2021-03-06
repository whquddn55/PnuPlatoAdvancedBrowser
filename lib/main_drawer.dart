import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/firebase_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/bugReportPage/admin_bug_report_page.dart';
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
          title: const Text('????????????'),
          onTap: () async {
            await showModalBottomSheet(context: context, useRootNavigator: true, builder: (context) => _renderLogoutBottomSheet(context));
          }),
      const Divider(height: 0),
      ListTile(
          trailing: const Icon(Icons.settings),
          title: const Text('??????'),
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const SettingPage()));
          }),
      const Divider(height: 0),
      ListTile(
        trailing: GetBuilder<FirebaseController>(
          builder: (controller) {
            int unread = controller.noticeUnreadCount();
            return Badge(child: const Icon(Icons.announcement), badgeContent: Text(unread.toString()), showBadge: unread != 0);
          },
        ),
        title: const Text('PPAB ????????????'),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const NoticeListPage()));
        },
      ),
      const Divider(height: 0),
      ListTile(
        trailing: GetBuilder<FirebaseController>(builder: (controller) {
          return Badge(
              child: const Icon(Icons.bug_report_outlined),
              badgeContent: Text(controller.unreadChatCount.toString()),
              showBadge: controller.unreadChatCount != 0);
        }),
        title: const Text('???????????????'),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => BugReportPage(studentId, false)));
        },
      ),
      const Divider(height: 30),
      ListTile(
        trailing: const Icon(Icons.warning_amber_rounded),
        title: const Text('?????????'),
        onTap: () async {
          var dialogResult = await showDialog(
            context: context,
            useRootNavigator: true,
            builder: (context) {
              return AlertDialog(
                content: const Text("?????? ????????? ???????????? ?????? ???????????????."),
                actions: [
                  TextButton(child: const Text("??????"), onPressed: () => Navigator.pop(context, false)),
                  TextButton(child: const Text("??????"), onPressed: () => Navigator.pop(context, true)),
                ],
              );
            },
          );
          if (dialogResult == true) {
            StorageController.clearAll();
            exit(0);
          }
        },
      ),

      /* Debug ??? */
      // const Divider(height: 0),
      // ListTile(
      //     trailing: const Icon(Icons.settings),
      //     title: const Text('???????????????????????????'),
      //     onTap: () {
      //       Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const AdminBugReportPage()));
      //     }),
      // const Divider(height: 0),
      // ListTile(
      //     trailing: const Icon(Icons.settings),
      //     title: const Text('???????????????'),
      //     onTap: () async {
      //       StorageController.removeTodo(AssignTodo(
      //         id: "13190943",
      //         title: "?????????Zoom??????",
      //         courseId: "119200",
      //         dueDate: DateTime.now(),
      //         availability: true,
      //         iconUrl: "",
      //         status: TodoStatus.doing,
      //         userDefined: false,
      //         checked: false,
      //       ));
      //       TodoController.to.loadTodoList();
      // StorageController.storeTodoList([]);
      // TodoController.to.loadTodoList();
      // await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
      // var tdlist = TodoController.to.todoList;
      // tdlist.add(ZoomTodo(
      //   id: "13190943",
      //   title: "?????????Zoom??????",
      //   courseId: "119200",
      //   dueDate: DateTime.now(),
      //   availability: true,
      //   iconUrl: "",
      //   status: TodoStatus.doing,
      //   userDefined: false,
      //   checked: false,
      // ));
      // StorageController.storeTodoList(tdlist);
      // TodoController.to.loadTodoList();
      //TodoController.to.progress.value = !TodoController.to.progress.value;
      //StorageController.storeLoginInformation(LoginInformation(loginStatus: true));
      // StorageController.storeNotificationList([]);
      // NotificationController.fetchNotificationList();
      // }),
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
        title: const Text('?????????'),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const LoginPage()));
        },
      ),
      const Divider(height: 30),
      ListTile(
        trailing: const Icon(Icons.warning_amber_rounded),
        title: const Text('?????????'),
        onTap: () async {
          var dialogResult = await showDialog(
            context: context,
            useRootNavigator: true,
            builder: (context) {
              return AlertDialog(
                content: const Text("?????? ????????? ???????????? ?????? ???????????????."),
                actions: [
                  TextButton(child: const Text("??????"), onPressed: () => Navigator.pop(context, false)),
                  TextButton(child: const Text("??????"), onPressed: () => Navigator.pop(context, true)),
                ],
              );
            },
          );
          if (dialogResult == true) {
            StorageController.clearAll();
            exit(0);
          }
        },
      ),
    ]);
  }

  Widget _renderLogoutBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        runSpacing: 20,
        children: [
          Text('???????????? ??? ?????? ????????? ????????? ?????????.', style: Get.textTheme.bodyText1),
          const Divider(height: 0, thickness: 1.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                child: Row(children: const [Icon(Icons.logout), Text('????????????')]),
                onPressed: () async {
                  Navigator.pop(context);
                  var dialogContext = await showProgressDialog(context, "???????????? ????????????...");
                  await Get.find<LoginController>().logout();
                  closeProgressDialog(dialogContext);
                },
                style: TextButton.styleFrom(primary: Get.textTheme.bodyText1!.color),
              ),
              TextButton(
                child: Row(
                  children: const [Icon(Icons.cancel_outlined), Text('??????')],
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
