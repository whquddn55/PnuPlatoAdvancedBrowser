import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:pnu_plato_advanced_browser/controllers/hive_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

abstract class NotificationController {
  static Future<void> initilize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'ppab_noti_group',
          channelKey: 'ppab_noti_download_status',
          channelName: '플라토 브라우저 다운로드 상태',
          channelDescription: '플라토 브라우저 다운로드 상태를 보여줌',
          onlyAlertOnce: true,
          enableLights: false,
          playSound: false,
          enableVibration: false,
          locked: true,
          channelShowBadge: false,
        ),
        NotificationChannel(
          channelGroupKey: 'ppab_noti_group',
          channelKey: 'ppab_noti_normal',
          channelName: '플라토 브라우저 일반 알림',
          channelDescription: '플라토 브라우저 알림을 보여줌',
          enableLights: true,
          playSound: true,
          enableVibration: true,
          channelShowBadge: true,
          defaultPrivacy: NotificationPrivacy.Public,
          importance: NotificationImportance.Max,
        )
      ],
    );

    // await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   AwesomeNotifications().requestPermissionToSendNotifications(channelKey: "ppab_noti_download_status");
    //   AwesomeNotifications().requestPermissionToSendNotifications(channelKey: "ppab_noti_normal");
    // });

    AwesomeNotifications().actionStream.listen((ReceivedNotification receivedNotification) {
      print(receivedNotification.id);
    });
  }

  static Future<List<Notification>> fetchNotificationList() async {
    await BackgroundService.sendData(BackgroundServiceAction.fetchNotificationList, data: null);
    var res = await HiveController.loadNotificationList();
    return res.reversed.toList();
  }

  static Future<void> clearNotificationList() async {
    await HiveController.clearByKey("notificationList");
  }
}
