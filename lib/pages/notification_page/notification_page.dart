import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification.dart' as noti;
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/notification_page/sections/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<noti.Notification> notificationList = [];

  @override
  void initState() {
    super.initState();
    NotificationController.fetchNotificationList().then((value) => setState(() => notificationList = value));
  }

  @override
  Widget build(BuildContext context) {
    if (notificationList.isEmpty) return const LoadingPage(msg: "로딩중 입니다...");
    return Scaffold(
      appBar: MainAppbar("알림"),
      drawer: const MainDrawer(),
      body: GetBuilder<LoginController>(
        builder: (controller) {
          if (controller.loginStatus == false) {
            return Builder(builder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const Center(
                    child: Text(
                  '로그인이 필요합니다.',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                )),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            });
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                var res = await NotificationController.fetchNotificationList();
                setState(() {
                  notificationList = res;
                });
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notificationList.length,
                itemBuilder: (context, index) {
                  return NotificationTile(notification: notificationList[index], index: index);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
