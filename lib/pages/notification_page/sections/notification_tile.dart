import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/notification.dart' as noti;

class NotificationTile extends StatelessWidget {
  final noti.Notification notification;
  final int index;
  const NotificationTile({Key? key, required this.notification, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Color eventColor;
    switch (notification.notificationType) {
      case noti.NotificationType.zoom:
        eventColor = zoomColor;
        break;
      case noti.NotificationType.vod:
        eventColor = videoColor;
        break;
      case noti.NotificationType.folder:
      case noti.NotificationType.ubfile:
        eventColor = Colors.orange.withOpacity(0.7);
        break;
      default:
        eventColor = Colors.grey.withOpacity(0.7);
    }

    return Stack(alignment: Alignment.centerLeft, children: [
      InkWell(
        onTap: () => null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0, left: 20.0),
          margin: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0, left: 15.0),
          decoration: BoxDecoration(color: const Color(0xffdddddd), borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(notification.title), Text(notification.body)],
          ),
        ),
      ),
      Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: eventColor,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          alignment: Alignment.center,
          child: Text((index + 1).toString(), style: const TextStyle(color: Colors.white))),
    ]);
    // return Padding(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Container(
    //     decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(4)),
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(notification.title),
    //         Text(notification.body),
    //       ],
    //     ),
    //   ),
    // );
  }
}
