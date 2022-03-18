import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/bakcground_download_controller.dart';

abstract class BackgroundNotificationController {
  static Future<void> initilize() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
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
        groupKey: 'ppab_noti_download_result',
        channelGroupKey: 'ppab_noti_download_result',
        channelKey: 'ppab_noti_download_result',
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
        channelGroupKey: 'ppab_noti_normal',
        channelKey: 'ppab_noti_normal',
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
      NotificationChannelGroup(channelGroupkey: 'ppab_noti_download_result', channelGroupName: 'ppab download result'),
      NotificationChannelGroup(channelGroupkey: 'ppab_noti_normal', channelGroupName: 'ppab normal'),
    ]);

    AwesomeNotifications().actionStream.listen((ReceivedAction receivedAction) {
      if (receivedAction.buttonKeyPressed == "cancel") {
        BackgroundDownloadController.tokenMap[receivedAction.id]?.cancel();
      }
    });
  }

  static Future<void> updateNotificationList() async {
    int page = 1;

    var notificationList = StorageController.loadNotificationList();

    while (true) {
      final List<Notification>? newNotificationList = await _fetchNewNotificationList(page);
      if (newNotificationList == null) return;

      final bool totallyUpdated = await _updateNotificationList(notificationList, newNotificationList);
      if (totallyUpdated == false) break;
      ++page;
    }

    StorageController.storeNotificationList(notificationList);
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
      }
    }

    int splitIndex = 0;
    for (int i = 0; i < notificationList.length; ++i) {
      if (DateTime.now().difference(notificationList[i].time).inDays < 30) break;
      splitIndex = i;
    }
    if (splitIndex != 0) {
      notificationList = notificationList.sublist(splitIndex);
    }
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
