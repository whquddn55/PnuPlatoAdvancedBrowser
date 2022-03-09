import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/no_glow_behavior.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification.dart' as noti;
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/notification_page/sections/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<noti.Notification>>(
      future: NotificationController.fetchNotificationList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const LoadingPage(msg: "로딩중 입니다...");
        if (snapshot.data == null) return const ErrorPage(msg: "알림 정보를 가져오는데 실패했어요...");
        var notificationList = snapshot.data!;
        return Scaffold(
          appBar: MainAppbar("알림"),
          body: ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: RefreshIndicator(
              onRefresh: () async {
                await NotificationController.clearNotificationList();
                setState(() {});
              },
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: notificationList.length,
                itemBuilder: (context, index) {
                  return NotificationTile(notification: notificationList[index], index: index);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
