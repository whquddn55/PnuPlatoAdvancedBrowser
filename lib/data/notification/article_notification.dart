import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/notification/notification.dart' as noti;
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

class ArticleNotification extends noti.Notification {
  ArticleNotification({required String title, required String body, required String url, required DateTime time})
      : super(title: title, body: body, url: url, time: time);

  @override
  void open(final BuildContext context) {
    final course = CourseController.getCourseByTitle(title);
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course, targetActivityId: url.split('bwid=')[1])));
  }

  @override
  Color getColor() => articleColor;
}
