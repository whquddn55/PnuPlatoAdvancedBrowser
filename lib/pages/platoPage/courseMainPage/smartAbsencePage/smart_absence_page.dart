import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/inappwebview_wrapper.dart';

class SmartAbsencePage extends StatelessWidget {
  final String courseId;
  const SmartAbsencePage({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InappwebviewWrapper(
      '스마트 출석부',
      CommonUrl.courseSmartAbsenceUrl + courseId,
      (controller, url) async {
        await controller.evaluateJavascript(
          source: '''document.getElementById('page-header').remove();
          document.getElementsByClassName('page-content-navigation')[0].remove();
          document.getElementsByClassName('nav nav-tabs nav-coursemos mb-3')[0].remove();
          document.getElementById('page-lnb').remove();
          document.body.style.margin = '0px';
          document.body.style.padding = '0px';''',
        );
      },
      alwaysPop: true,
    );
  }
}
