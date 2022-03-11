import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

class ZoomNotification extends noti.Notification {
  ZoomNotification({required String title, required String body, required String url, required DateTime time})
      : super(title: title, body: body, url: url, time: time, color: zoomColor);

  ZoomNotification.fromJson(Map<String, dynamic> json)
      : super(
          title: json["title"],
          body: json["body"],
          url: json["url"],
          time: DateTime.parse(json["time"]),
          color: zoomColor,
        );

  // @override
  // bool operator ==(final Object other) => other.runtimeType == ZoomNotification && hashCode == other.hashCode;
}
