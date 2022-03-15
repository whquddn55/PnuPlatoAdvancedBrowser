import 'package:pnu_plato_advanced_browser/controllers/hive_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

abstract class NotificationController {
  static Future<List<Notification>> fetchNotificationList() async {
    await BackgroundService.sendData(BackgroundServiceAction.fetchNotificationList, data: null);
    var res = await HiveController.loadNotificationList();
    return res.reversed.toList();
  }

  static Future<void> clearNotificationList() async {
    await HiveController.clearByKey("notificationList");
  }
}
