import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/url_bottom_sheet.dart';

class UrlCourseActivity extends CourseActivity {
  UrlCourseActivity({
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
      builder: (context) => UrlBottomSheet(activity: this),
    );
  }

  @override
  Future<void> open(final BuildContext context) async {
    final progressContext = await showProgressDialog(context, "로딩중입니다...");
    var response = await requestGet(CommonUrl.courseUrlViewUrl + id + '&redirect=1',
        isFront: true, options: Options(followRedirects: false, validateStatus: (status) => status == 303));
    closeProgressDialog(progressContext);

    if (response == null) {
      ExceptionController.onExpcetion("response is null on urlOpen", true);
      return;
    }
    if (response.requestOptions.path == "null") {
      return;
    }

    final bool openResult = await openBrowser(response.headers.value("location")!);
    if (openResult == false) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text("크롬, 사파리 브라우저가 설치되지 않았어요."),
          actions: [TextButton(child: const Text("확인"), onPressed: Navigator.of(context).pop)],
        ),
      );
    }
  }
}
