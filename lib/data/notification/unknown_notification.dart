import 'dart:ui';

import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;

class UnknownNotification extends noti.Notification {
  UnknownNotification({
    int? isarId,
    required String title,
    required String body,
    required String? url,
    required DateTime time,
  }) : super(isarId: isarId, title: title, body: body, url: url, time: time, type: "unknown");

  @override
  Color getColor() => unknownColor;
}
