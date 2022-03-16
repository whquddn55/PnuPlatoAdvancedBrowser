import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';

abstract class BackgroundNotificationController {
  static Future<void> updateNotificationList() async {
    int page = 1;

    var notificationList = await StorageController.loadNotificationList();

    while (true) {
      final List<Notification>? newNotificationList = await _fetchNewNotificationList(page);
      if (newNotificationList == null) return;

      final bool totallyUpdated = await _updateNotificationList(notificationList, newNotificationList);
      if (totallyUpdated == false) break;
      ++page;
    }

    await StorageController.storeNotificationList(notificationList);
  }

  static Future<bool> _updateNotificationList(List<Notification> notificationList, final List<Notification> newNotificationList) async {
    int addedCnt = 0;
    while (newNotificationList.isNotEmpty) {
      var newNotification = newNotificationList.last;
      newNotificationList.removeLast();

      int prvNotificationIndex = notificationList.indexOf(newNotification);
      if (prvNotificationIndex == -1) {
        notificationList.add(newNotification);
        await showNotification(newNotification);
        ++addedCnt;
      } else {
        newNotification.isarId = notificationList[prvNotificationIndex].isarId;
        notificationList[prvNotificationIndex] = newNotification;
      }
    }

    int splitIndex = 0;
    for (int i = 0; i < notificationList.length; ++i) {
      if (DateTime.now().difference(notificationList[i].time).inDays < 30) break;
      splitIndex = i;
    }
    notificationList = notificationList.sublist(splitIndex);
    return addedCnt == 15;
  }

  static Future<List<Notification>?> _fetchNewNotificationList(int page) async {
    var response = await requestGet(CommonUrl.notificationUrl + page.toString(), isFront: false, retry: 3);

    if (response == null) {
      return null;
    }

    Document document = Document.html(response.data);

    List<Notification> newNotificationList = [];
    for (var notificationItem in document.getElementsByClassName('notification-item')) {
      final String timeago = notificationItem.getElementsByClassName('timeago')[0].text;
      final String courseName = notificationItem.getElementsByClassName('media-heading')[0].text.trim().split(' ')[0];
      final String content = notificationItem
              .getElementsByClassName('media-body')[0]
              .text
              .replaceAll(notificationItem.getElementsByClassName('media-heading')[0].text, '')
              .replaceAll(timeago, '') +
          ' - ' +
          timeago;
      final String? url = notificationItem.attributes['href'];

      var newNotification =
          Notification(title: courseName, body: content, url: url, time: DateTime.now(), type: url?.split('/')[4] ?? "removed").transType();
      newNotificationList.add(newNotification);
    }

    return newNotificationList;
  }

  static Future<void> showNotification(final Notification nofitication) async {
    nofitication.show();
  }
}
