import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/inappwebview_wrapper.dart';

class UnknownCourseActivity extends CourseActivity {
  final String? url;
  UnknownCourseActivity({
    required String title,
    required String id,
    required String courseTitle,
    required String courseId,
    required this.url,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? lateDate,
    required String description,
    required String info,
    String? iconUrl,
    String availablilityInfo = '',
    bool availablility = true,
  }) : super(
          title: title,
          id: id,
          courseTitle: courseTitle,
          courseId: courseId,
          startDate: startDate,
          endDate: endDate,
          lateDate: lateDate,
          description: description,
          info: info,
          iconUrl: iconUrl,
          availablilityInfo: availablilityInfo,
          availablility: availablility,
        );

  @override
  Future<void> openBottomSheet(final BuildContext context) async {
    await open(context);
  }

  @override
  Future<void> open(final BuildContext context) async {
    if (url == null) return;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("저 힘들어요..."),
          content: const Text("퀴즈, 설문조사, 토론은 아직 구현되지 않았어요."),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: Navigator.of(context).pop,
            )
          ],
        );
      },
    );
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => InappwebviewWrapper(
          title,
          url!,
          (controller, uri) async {
            await controller.evaluateJavascript(source: '''
            document.getElementById('page-header').remove();
            document.getElementsByClassName('page-content-navigation')[0].remove(); 
            document.body.style.margin = '0px';
            document.body.style.padding = '0px';
            ''');
          },
        ),
      ),
    );
  }
}
