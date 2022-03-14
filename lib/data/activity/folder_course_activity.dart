import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/file_bottom_sheet.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/folder_bottom_sheet.dart';

class FolderCourseActivity extends CourseActivity {
  FolderCourseActivity({
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
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => FolderBottomSheet(activity: this, courseTitle: courseTitle, courseId: courseId),
    );
  }

  @override
  Future<void> open(final BuildContext context) async {
    throw UnimplementedError("구현되지 않음");
  }
}
