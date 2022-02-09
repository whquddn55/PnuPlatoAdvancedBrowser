import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';
import 'package:pnu_plato_advanced_browser/controllers/notice_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';

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
  static const String courseOnlineAbsenceUrl = 'https://plato.pusan.ac.kr/report/ubcompletion/progress.php?id=';
  static const String courseSmartAbsenceUrl = 'https://plato.pusan.ac.kr/local/ubattendance/my_status.php?id=';
  static const String courseGradeUrl = 'https://plato.pusan.ac.kr/grade/report/user/index.php?id=';
  static const String courseArticleUrl = 'https://plato.pusan.ac.kr/mod/ubboard/article.php?';
  static const String courseBoardUrl = 'https://plato.pusan.ac.kr/mod/ubboard/view.php?';

  static const String vodViewerUrl = 'https://plato.pusan.ac.kr/mod/vod/viewer.php?id=';
  static const String fileViewerUrl = 'https://plato.pusan.ac.kr/mod/ubfile/view.php?id=';

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
    customRender: {
      "table": (context, child) {
        final _scrollController = ScrollController();
        return Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: (context.tree as TableLayoutElement).toWidget(context),
          ),
        );
      }
    },
    style: {
      ".badge": Style(
        color: Colors.transparent,
      ),
    },
  );
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

Widget iconFromExtension(String fileExtension) {
  switch (fileExtension) {
    case 'asf':
    case 'avi':
    case '3gp':
    case 'm4u':
    case 'm4v':
    case 'mov':
    case 'mp4':
    case 'mpc':
    case 'mpe':
    case 'mpeg':
    case 'mpg':
    case 'mpg4':
      return SvgPicture.asset('assets/icons/video.svg', color: Get.textTheme.bodyText2!.color, height: 20);
    case 'mpga':
    case 'ogg':
    case 'm3u':
    case 'm4a':
    case 'm4b':
    case 'm4p':
    case 'mp2':
    case 'mp3':
    case 'rmvb':
    case 'wav':
    case 'wma':
    case 'wmv':
      return SvgPicture.asset('assets/icons/mp3.svg', color: Get.textTheme.bodyText2!.color, height: 20);
    case 'bmp':
    case 'gif':
    case 'jpeg':
    case 'jpg':
    case 'png':
      return SvgPicture.asset('assets/icons/image.svg', color: Get.textTheme.bodyText2!.color, height: 20);

    case 'pdf':
      return SvgPicture.asset('assets/icons/pdf.svg', color: Get.textTheme.bodyText2!.color, height: 20);

    case 'doc':
    case 'docx':
      return SvgPicture.asset('assets/icons/word.svg', color: Get.textTheme.bodyText2!.color, height: 20);

    case 'xls':
    case 'xlsx':
    case 'csv':
      return SvgPicture.asset('assets/icons/excel.svg', color: Get.textTheme.bodyText2!.color, height: 20);

    case 'pps':
    case 'ppt':
    case 'pptx':
      return SvgPicture.asset('assets/icons/powerpoint.svg', color: Get.textTheme.bodyText2!.color, height: 20);

    case 'htm':
    case 'html':
      return SvgPicture.asset('assets/icons/html.svg', color: Get.textTheme.bodyText2!.color, height: 20);

    case 'zip':
    case 'gzip':
    case 'gtar':
    case 'tgz':
    case 'tar':
    case 'z':
      return SvgPicture.asset('assets/icons/zip.svg', color: Get.textTheme.bodyText2!.color, height: 20);

    case 'txt':
      return SvgPicture.asset('assets/icons/text.svg', color: Get.textTheme.bodyText2!.color, height: 20);

    default:
      return SvgPicture.asset('assets/icons/file.svg', color: Get.textTheme.bodyText2!.color, height: 20);
  }
}
