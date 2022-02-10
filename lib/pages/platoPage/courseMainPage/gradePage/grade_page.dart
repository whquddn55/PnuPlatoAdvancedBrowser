import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/inappwebview_wrapper.dart';

class GradePage extends StatelessWidget {
  final String courseId;

  const GradePage({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InappwebviewWrapper('성적', CommonUrl.courseGradeUrl + courseId, (controller, url) async {
      await controller.evaluateJavascript(
        source: "document.getElementById('page-header').remove();document.getElementsByClassName('page-content-navigation')[0].remove();",
      );
    });
  }
}
