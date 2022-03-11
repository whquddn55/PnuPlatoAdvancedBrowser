import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/file_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/folder_notification.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;
import 'package:pnu_plato_advanced_browser/data/notification/vod_notification.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

class NotificationTile extends StatelessWidget {
  final noti.Notification notification;
  final int index;
  const NotificationTile({Key? key, required this.notification, required this.index}) : super(key: key);

  void _tapEvent(final BuildContext context) {
    final course = Get.find<CourseController>().getCourseByTitle(notification.title);
    if (course == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("에러"),
          content: const Text("강의를 찾을 수 없습니다."),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
      return;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course, targetActivityId: notification.url.split('?id=')[1])));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.centerLeft, children: [
      InkWell(
        onTap: () => _tapEvent(context),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
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
      Container(height: 30, width: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white)),
      Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: notification.color,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          alignment: Alignment.center,
          child: Text((index + 1).toString(), style: const TextStyle(color: Colors.white))),
    ]);
  }
}
