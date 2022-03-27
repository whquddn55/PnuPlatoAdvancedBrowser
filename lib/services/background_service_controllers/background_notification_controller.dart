import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/bakcground_download_controller.dart';

abstract class BackgroundNotificationController {
  static Future<void> initialize() async {
    await NotificationController.initialize();

    AwesomeNotifications().actionStream.listen((ReceivedAction receivedAction) {
      if (receivedAction.buttonKeyPressed == "cancel") {
        BackgroundDownloadController.tokenMap[receivedAction.id]?.cancel();
      }
    });
  }

  static Future<void> updateNotificationList(final bool enableNotify) async {
    final notificationList = StorageController.loadNotificationList();
    final newNotificationList = await _fetchNewNotificationList(notificationList);
    StorageController.storeNotificationList(_updateNotificationList(notificationList, newNotificationList, enableNotify));
    StorageController.storeLastNotiSyncTime(DateTime.now());
  }

  static Future<List<Notification>> _fetchNewNotificationList(final List<Notification> notificationList) async {
    int page = 1;
    final List<Notification> newNotificationList = [];
    while (true) {
      var response = await requestGet(CommonUrl.notificationUrl + page.toString(), isFront: false, retry: 3);

      if (response == null) {
        return [];
      }

      Document document = Document.html(response.data);

      bool totallyUpdate = document.getElementsByClassName('notification-item').isNotEmpty;
      for (var notificationItem in document.getElementsByClassName('notification-item')) {
        final String? url = notificationItem.attributes['href'];
        if (url == null) continue;
        final String timeago = notificationItem.getElementsByClassName('timeago')[0].text;
        final String courseName = notificationItem.getElementsByClassName('media-heading')[0].text.split('(')[0].trim();
        final String content = notificationItem
            .getElementsByClassName('media-body')[0]
            .text
            .replaceAll(notificationItem.getElementsByClassName('media-heading')[0].text, '')
            .replaceAll(timeago, '');

        final newNotification = Notification(title: courseName, body: content, url: url, time: DateTime.now(), type: url.split('/')[4]).transType();
        if (notificationList.contains(newNotification)) {
          totallyUpdate = false;
          continue;
        }
        newNotificationList.add(newNotification);
      }

      if (!totallyUpdate) {
        break;
      }
      ++page;
    }
    return newNotificationList;
  }

  static List<Notification> _updateNotificationList(
      final List<Notification> notificationList, final List<Notification> newNotificationList, final bool enableNotify) {
    for (var notification in newNotificationList) {
      if (enableNotify == true) {
        notification.show();
      }
    }
    return newNotificationList + notificationList;
  }
}
