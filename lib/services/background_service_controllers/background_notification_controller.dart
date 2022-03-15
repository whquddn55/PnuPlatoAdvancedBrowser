import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/hive_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';

abstract class BackgroundNotificationController {
  static Future<void> updateNotificationList() async {
    int page = 1;

    final List<Notification> newNotificationList = [];
    while (true) {
      List<Notification>? res = await _fetchNewNotificationList(page);
      if (res == null) return;

      newNotificationList.addAll(res);
      if (res.length != 15) break;
      ++page;
    }

    await _updateNotificationList(newNotificationList);
  }

  static Future<void> _updateNotificationList(final List<Notification> newNotificationList) async {
    var notificationList = await HiveController.loadNotificationList();
    while (newNotificationList.isNotEmpty) {
      var newNotification = newNotificationList.last;
      newNotificationList.removeLast();

      notificationList.add(newNotification);
      await showNotification(newNotification);
    }

    int splitIndex = 0;
    for (int i = 0; i < notificationList.length; ++i) {
      if (DateTime.now().difference(notificationList[i].time).inDays < 30) break;
      splitIndex = i;
    }
    notificationList = notificationList.sublist(splitIndex);

    await HiveController.storeNotificationList(notificationList);
  }

  static Future<List<Notification>?> _fetchNewNotificationList(int page) async {
    var response = await requestGet(CommonUrl.notificationUrl + page.toString(), isFront: false, retry: 3);

    if (response == null) {
      return null;
    }

    Document document = Document.html(response.data);

    List<Notification> notificationList = await HiveController.loadNotificationList();
    List<Notification> newNotificationList = [];
    for (var notificationItem in document.getElementsByClassName('notification-item')) {
      if (notificationItem.localName != 'a') continue;
      final String timeago = notificationItem.getElementsByClassName('timeago')[0].text;
      final String courseName = notificationItem.getElementsByClassName('media-heading')[0].text.trim().split(' ')[0];
      final String content = notificationItem
              .getElementsByClassName('media-body')[0]
              .text
              .replaceAll(notificationItem.getElementsByClassName('media-heading')[0].text, '')
              .replaceAll(timeago, '') +
          ' - ' +
          timeago;
      final String url = notificationItem.attributes['href']!;

      var newNotification =
          Notification.fromJson({"title": courseName, "body": content, "url": url, "time": DateTime.now().toString(), "type": url.split('/')[4]});
      if (notificationList.contains(newNotification)) break;
      newNotificationList.add(newNotification);
    }

    return newNotificationList;
  }

  static Future<void> showNotification(final Notification nofitication) async {
    nofitication.show();
  }
}
