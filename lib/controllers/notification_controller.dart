import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

enum NotificationType { normal, result, progress }

abstract class NotificationController {
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelGroupKey: 'ppab_noti',
        channelKey: 'ppab_noti_download_progress',
        channelName: '플라토 브라우저 다운로드 진행 상태',
        channelDescription: '플라토 브라우저 다운로드 진행 상태를 보여줌',
        onlyAlertOnce: true,
        enableLights: false,
        playSound: false,
        enableVibration: false,
        locked: true,
        channelShowBadge: false,
      ),
      NotificationChannel(
        channelGroupKey: 'ppab_noti',
        channelKey: 'ppab_noti_download_result',
        groupKey: "ppab_noti_download_result",
        channelName: '플라토 브라우저 다운로드 결과',
        channelDescription: '플라토 브라우저 다운로드 결과를 보여줌',
        enableLights: true,
        playSound: true,
        enableVibration: true,
        channelShowBadge: true,
        defaultPrivacy: NotificationPrivacy.Public,
        importance: NotificationImportance.Max,
      ),
      NotificationChannel(
        channelGroupKey: 'ppab_noti',
        channelKey: 'ppab_noti_normal',
        groupKey: "ppab_noti_normal",
        channelName: '플라토 브라우저 일반 알림',
        channelDescription: '플라토 브라우저 알림을 보여줌',
        enableLights: true,
        playSound: true,
        enableVibration: true,
        channelShowBadge: true,
        defaultPrivacy: NotificationPrivacy.Public,
        importance: NotificationImportance.Max,
      ),
    ], channelGroups: [
      NotificationChannelGroup(channelGroupkey: 'ppab_noti', channelGroupName: 'PPAB 알림'),
    ]);
  }

  static Future<List<Notification>> fetchNotificationList() async {
    await BackgroundService.sendData(BackgroundServiceAction.fetchNotificationList, data: null);
    var res = StorageController.loadNotificationList();
    return res.reversed.toList();
  }

  static Future<void> dismissNotification(final int id) async {
    await AwesomeNotifications().dismiss(id);
  }

  static Future<void> showNotification(
      final NotificationType type, final int id, final String title, final String body, final Map<String, String> payload,
      {int? progress}) async {
    switch (type) {
      case NotificationType.normal:
        payload["type"] = type.name;
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'ppab_noti_normal',
            title: title,
            body: body,
            payload: payload,
            displayOnForeground: true,
            wakeUpScreen: true,
            displayOnBackground: true,
            showWhen: true,
          ),
        );
        break;
      case NotificationType.result:
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'ppab_noti_download_result',
            title: title,
            body: body,
            autoDismissible: true,
            displayOnForeground: true,
            displayOnBackground: true,
            showWhen: true,
          ),
        );
        break;
      case NotificationType.progress:
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'ppab_noti_download_progress',
            groupKey: id.toString(),
            title: title,
            body: body,
            autoDismissible: false,
            displayOnForeground: true,
            displayOnBackground: true,
            locked: true,
            showWhen: true,
            progress: progress,
            notificationLayout: NotificationLayout.ProgressBar,
          ),
          actionButtons: [
            NotificationActionButton(
              key: "cancel",
              label: "취소",
              buttonType: ActionButtonType.KeepOnTop,
            )
          ],
        );
        break;
    }
  }
}
