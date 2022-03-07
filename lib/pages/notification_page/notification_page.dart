import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pnu_plato_advanced_browser/no_glow_behavior.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification.dart' as noti;
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';

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
        print(snapshot.data);
        if (snapshot.data == null) return const ErrorPage(msg: "알림 정보를 가져오는데 실패했어요...");
        var notificationList = snapshot.data!;
        return Scaffold(
          appBar: MainAppbar("알림"),
          body: ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView.builder(
                itemCount: notificationList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notificationList[index].title),
                          Text(notificationList[index].body),
                          Text(notificationList[index].url),
                          Text(notificationList[index].time.toString()),
                          Text(notificationList[index].notificationType.name),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
