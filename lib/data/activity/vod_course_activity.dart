import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/vod_bottom_sheet.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/vodPage/vod_page.dart';

class VodCourseActivity extends CourseActivity {
  VodCourseActivity({
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
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) => VodBottomSheet(activity: this, courseTitle: courseTitle, courseId: courseId),
    );
  }

  @override
  Future<void> open(final BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => VodPage(id: id)));
  }

  Future<void> download() async {
    Uri uri = await CourseController.getM3u8Uri(id);
    if (uri.toString() == '') {
    } else {
      var downloadResult = await DownloadController.to.enQueue(
        url: uri.toString(),
        title: title,
        courseTitle: courseTitle,
        courseId: courseId,
        type: DownloadType.m3u8,
      );
    }
  }
}
