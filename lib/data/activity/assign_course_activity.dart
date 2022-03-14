import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/assignPage/assign_page.dart';

class AssignCourseActivity extends CourseActivity {
  AssignCourseActivity({
    required String title,
    required String id,
    required String courseTitle,
    required String courseId,
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
    await Navigator.push(context, MaterialPageRoute(builder: (context) => AssignPage(assignId: id, courseId: courseId, courseTitle: courseTitle)));
  }
}
