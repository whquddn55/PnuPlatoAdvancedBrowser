import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

abstract class NotificationController {
  static Future<List<Notification>> fetchNotificationList() async {
    await BackgroundService.sendData(BackgroundServiceAction.fetchNotificationList, data: null);
    var res = StorageController.loadNotificationList();
    return res.reversed.toList();
  }
}
