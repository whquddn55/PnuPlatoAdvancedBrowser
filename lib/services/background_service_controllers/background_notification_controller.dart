import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BackgroundNotificationController {
  static List<Notification> notificationList = [];

  static Future<void> initialize() async {
    final preference = await SharedPreferences.getInstance();
    notificationList = preference.getStringList("notificationList")?.map<Notification>((e) => Notification.fromJson(jsonDecode(e))).toList() ?? [];

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings, onSelectNotification: _onSelectNotification);
  }

  static void _onSelectNotification(String? arg) {
    print("[DEBUG] $arg");
  }

  static Future<void> fetchNotification() async {
    int page = 1;

    final List<Notification> newNotificationList = [];
    while (true) {
      List<Notification> res = await _fetchNewNotificationList(page);
      newNotificationList.addAll(res);
      if (res.length != 15) break;
      ++page;
    }

    while (newNotificationList.isNotEmpty) {
      var newNotification = newNotificationList.last;
      newNotificationList.removeLast();

      notificationList.add(newNotification);
      await showNotification(newNotification);
    }

    notificationList = notificationList.sublist(max(0, notificationList.length - 15));

    final preference = await SharedPreferences.getInstance();
    await preference.setStringList("notificationList", notificationList.map<String>((e) => jsonEncode(e)).toList());
  }

  static Future<List<Notification>> _fetchNewNotificationList(int page) async {
    var response = await requestGet(CommonUrl.notificationUrl + page.toString(), isFront: false, retry: 3);

    if (response == null) {
      return [];
    }

    Document document = Document.html(response.data);

    List<Notification> newNotificationList = [];
    for (var notificationItem in document.getElementsByClassName('notification-item')) {
      final String timeago = notificationItem.getElementsByClassName('timeago')[0].text;
      final String courseName = notificationItem.getElementsByClassName('media-heading')[0].text.split(' ')[0] + ' - ' + timeago;
      final String content = notificationItem
          .getElementsByClassName('media-body')[0]
          .text
          .replaceAll(notificationItem.getElementsByClassName('media-heading')[0].text, '')
          .replaceAll(timeago, '');
      final String url = notificationItem.attributes['href']!;
      final NotificationType notificationType = NotificationType.values.byName(url.split('/')[4]);

      var newNotification = Notification(title: courseName, body: content, url: url, notificationType: notificationType);
      if (notificationList.contains(newNotification)) break;
      newNotificationList.add(newNotification);
    }

    return newNotificationList;
  }

  static Future<void> showNotification(final Notification nofitication) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const android = AndroidNotificationDetails('thuthi_plato_noti', '플라토 브라우저 알림',
        channelDescription: '플라토 브라우저에서 새 알림을 보여줌', importance: Importance.max, priority: Priority.high);
    const detail = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(nofitication.hashCode, nofitication.title, nofitication.body, detail, payload: nofitication.url);
  }
}
