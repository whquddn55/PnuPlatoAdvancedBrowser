import 'package:pnu_plato_advanced_browser/data/notification.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

abstract class NotificationController {
  static Future<List<Notification>> fetchNotificationList() async {
    return List<Notification>.from(await BackgroundService.sendData(BackgroundServiceAction.fetchNotificationList, data: null));
  }
}
