import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

class UnknownNotification extends noti.Notification {
  UnknownNotification({required String title, required String body, required String url, required DateTime time})
      : super(title: title, body: body, url: url, time: time, color: unknownColor);

  UnknownNotification.fromJson(Map<String, dynamic> json)
      : super(
          title: json["title"],
          body: json["body"],
          url: json["url"],
          time: DateTime.parse(json["time"]),
          color: unknownColor,
        );
}
