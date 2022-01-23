import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';

abstract class CommonUrl {
  static const String platoMainUrl = 'https://plato.pusan.ac.kr/';
  static const String platoUserInformationUrl = 'https://plato.pusan.ac.kr/user/user_edit.php';
  static const String platoCalendarUrl = 'https://plato.pusan.ac.kr/calendar/export.php';
  static const String defaultAvatarUrl = 'https://plato.pusan.ac.kr/theme/image.php/coursemosv2/core/1636448872/u/f1';
  static const String loginUrl = 'https://plato.pusan.ac.kr/login/index.php';
  static const String loginErrorUrl = 'https://plato.pusan.ac.kr/login.php?errorcode=3';
  static const String notificationUrl = 'https://plato.pusan.ac.kr/local/ubnotification/';
  static const String logoutUrl = 'https://plato.pusan.ac.kr/login/logout.php?sesskey=';
  static const String courseListUrl = 'https://plato.pusan.ac.kr/local/ubion/user/index.php?';
  static const String courseMainUrl = 'https://plato.pusan.ac.kr/course/view.php?id=';
  static const String courseVideoUrl = 'https://plato.pusan.ac.kr/mod/vod/index.php?id=';
  static const String courseAssignUrl = 'https://plato.pusan.ac.kr/mod/assign/index.php?id=';
  static const String courseZoomUrl = 'https://plato.pusan.ac.kr/mod/zoom/index.php?id=';
  static const String courseQuizUrl = 'https://plato.pusan.ac.kr/mod/quiz/index.php?id=';
  static const String courseFileUrl = 'https://plato.pusan.ac.kr/mod/ubfile/index.php?id=';
  static const String courseUrlUrl = 'https://plato.pusan.ac.kr/mod/url/index.php?id=';
  static const String courseFolderUrl = 'https://plato.pusan.ac.kr/mod/folder/index.php?id=';
  static const String courseReportUrl = 'https://plato.pusan.ac.kr/grade/report/user/index.php?id=';
  static const String courseVideoProgressUrl = 'https://plato.pusan.ac.kr/report/ubcompletion/user_progress_a.php?id=';
  static const String courseOnlineAbsenceUrl = 'https://plato.pusan.ac.kr/report/ubcompletion/user_progress_a.php?id=';
  static const String courseSmartAbsenceUrl = 'https://plato.pusan.ac.kr/local/ubattendance/my_status.php?id=';

  static const String academicCalendarUrl = 'https://www.pusan.ac.kr/kor/CMS/Haksailjung/PopupView.do';
  static const String findIdUrl = 'https://u-pip.pusan.ac.kr/rSSO/popup/FindID_step1.asp';
  static const String findPwUrl = 'https://u-pip.pusan.ac.kr/rSSO/popup/FindPassword_step1.asp';
}

/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

class NFMarquee extends StatelessWidget {
  const NFMarquee({
    Key? key,
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.velocity = 30.0,
    this.blankSpace = 65.0,
    this.startAfter = const Duration(milliseconds: 2000),
    this.pauseAfterRound = const Duration(milliseconds: 2000),
    this.color = Colors.black,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double velocity;
  final double blankSpace;
  final Duration startAfter;
  final Duration pauseAfterRound;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (fontSize + 13.0) * MediaQuery.of(context).textScaleFactor,
      child: AutoSizeText(
        text,
        minFontSize: fontSize,
        maxFontSize: fontSize,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
        overflowReplacement: Marquee(
          crossAxisAlignment: CrossAxisAlignment.start,
          text: text,
          blankSpace: blankSpace,
          accelerationCurve: Curves.easeOutCubic,
          velocity: velocity,
          startAfter: startAfter,
          pauseAfterRound: pauseAfterRound,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
        ),
      ),
    );
  }
}

Future<dio.Response?> request(String url, {dio.Options? options, Function? callback}) async {
  dio.Response? response;
  int retry = 0;
  while (retry < 5) {
    try {
      response = await dio.Dio().get(url, options: options);
      if (parse(response.data).children[0].attributes['class'] == 'html_login') {
        retry++;
        if (callback != null) {
          await callback();
        }
      } else {
        break;
      }
    } on dio.DioError catch (e, _) {
      retry++;
    }
  }
  return response;
}

Html renderHtml(String html) {
  html = html.replaceAll('<br>', '');
  return Html(
    data: html,
    customImageRenders: {
      networkSourceMatcher(): (context, attributes, element) {
        return Container(
          margin: const EdgeInsets.all(8),
          child: CachedNetworkImage(
            imageUrl: attributes["src"]!,
            httpHeaders: {
              'Cookie': Get.find<UserDataController>().moodleSessionKey,
            },
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.5),
          ),
        );
      },
    },
  );
}

void showBugReport(String msg) {
  var _controller = TextEditingController();
  Get.defaultDialog(
      title: '버그리포트',
      barrierDismissible: false,
      content: Column(
        children: [
          SizedBox(
            width: Get.width,
            height: 300,
            child: TextFormField(
              maxLines: null,
              minLines: null,
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: '상세한 상황을 설명해주세요.\n(ex: A를 하려하다가 B버튼을 누르니 C에러가 떴습니다.)',
              ),
              autofocus: true,
              expands: true,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('작성하신 내용과 내부 버그 정보를 포함하여 서버에 전송하게 됩니다.'),
          )
        ],
      ),
      cancel: TextButton(
        child: Text('취소', style: TextStyle(color: Get.theme.disabledColor)),
        onPressed: () => Get.back(),
      ),
      confirm: TextButton(
        child: const Text('전송'),
        onPressed: () {
          /* TODO: 버그 전송 */
          print(_controller.text);
          Get.back();
        },
      ));
}
