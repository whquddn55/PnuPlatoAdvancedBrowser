import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/zoom_bottom_sheet.dart';

class ZoomCourseActivity extends CourseActivity {
  ZoomCourseActivity({
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
      builder: (context) => ZoomBottomSheet(
        activity: this,
        courseTitle: courseTitle,
        courseId: courseId,
      ),
    );
  }

  @override
  Future<void> open(final BuildContext context) async {
    var response = await requestGet(CommonUrl.courseZoomOpenUrl + id,
        isFront: true, options: Options(followRedirects: false, validateStatus: (status) => status == 303));

    if (response == null) {
      /* TODO: 에러 */
      return;
    }

    ChromeSafariBrowser().open(
        url: Uri.parse(response.headers.value("location")!),
        options: ChromeSafariBrowserClassOptions(
            android: AndroidChromeCustomTabsOptions(showTitle: false, toolbarBackgroundColor: Colors.white), ios: IOSSafariOptions()));
  }
}
