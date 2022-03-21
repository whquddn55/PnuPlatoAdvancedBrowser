import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/login_builder_page.dart';
import 'package:pnu_plato_advanced_browser/pages/notification_page/sections/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<noti.Notification> notificationList = StorageController.loadNotificationList().reversed.toList();

  @override
  void initState() {
    super.initState();
    NotificationController.fetchNotificationList().then(
      (value) => setState(
        () {
          notificationList = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar("알림"),
      drawer: const MainDrawer(),
      body: LoginBuilderPage(() {
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
