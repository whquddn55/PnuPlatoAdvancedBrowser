import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';

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
          content: const Text("아직 구현되지 않았어요. 버그리포트를 통해서 알려주세요.\n브라우저로 이동시켜드릴게요."),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: Navigator.of(context).pop,
            )
          ],
        );
      },
    );
    await ChromeSafariBrowser().open(url: Uri.parse(url!));
  }
}
