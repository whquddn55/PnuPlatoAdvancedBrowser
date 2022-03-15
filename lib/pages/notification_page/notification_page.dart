import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/login_builder_page.dart';
import 'package:pnu_plato_advanced_browser/pages/notification_page/sections/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<noti.Notification> notificationList = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    NotificationController.fetchNotificationList().then((value) => setState(() {
          notificationList = value;
          _loaded = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar("알림"),
      drawer: const MainDrawer(),
      body: LoginBuilderPage(() {
        if (_loaded == false) return const LoadingPage(msg: "로딩중 입니다...");

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
      }),
    );
  }
}
