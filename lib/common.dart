import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/components/inner_player.dart';
import 'package:pnu_plato_advanced_browser/data/login_information.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';
import 'package:url_launcher/url_launcher.dart';

void printLog(final dynamic msg) {
  print("[DEBUG] ${msg.toString()}");
}

abstract class CommonUrl {
  static const String platoActionUrl = 'https://plato.pusan.ac.kr/theme/coursemosv2/action.php';
  static const String platoUserInformationUrl = 'https://plato.pusan.ac.kr/user/user_edit.php';
  static const String platoCalendarUrl = 'https://plato.pusan.ac.kr/calendar/export.php';
  static const String defaultAvatarUrl = 'https://plato.pusan.ac.kr/theme/image.php/coursemosv2/core/1636448872/u/f1';
  static const String loginUrl = 'https://plato.pusan.ac.kr/login/index.php';
  static const String loginErrorUrl = 'https://plato.pusan.ac.kr/login.php?errorcode=3';
  static const String notificationUrl = 'https://plato.pusan.ac.kr/local/ubnotification/index.php?page=';
  static const String logoutUrl = 'https://plato.pusan.ac.kr/login/logout.php?sesskey=';
  static const String courseListUrl = 'https://plato.pusan.ac.kr/local/ubion/user/index.php?';
  static const String courseMainUrl = 'https://plato.pusan.ac.kr/course/view.php?id=';
  static const String courseVodUrl = 'https://plato.pusan.ac.kr/mod/vod/index.php?id=';
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
  static const String courseBoardUrl = 'https://plato.pusan.ac.kr/mod/ubboard/view.php?id=';
  static const String courseBoardWriteUrl = 'https://plato.pusan.ac.kr/mod/ubboard/write.php?id=';
  static const String courseBoardActionUrl = 'https://plato.pusan.ac.kr/mod/ubboard/action.php';
  static const String courseAssignViewUrl = 'https://plato.pusan.ac.kr/mod/assign/view.php?id=';
  static const String courseUrlViewUrl = 'https://plato.pusan.ac.kr/mod/url/view.php?id=';
  static const String courseVodViewUrl = 'https://plato.pusan.ac.kr/mod/vod/view.php?id=';
  static const String courseFolderViewUrl = 'https://plato.pusan.ac.kr/mod/folder/view.php?id=';
  static const String courseZoomViewUrl = 'https://plato.pusan.ac.kr/mod/zoom/view.php?id=';
  static const String courseZoomOpenUrl = 'https://plato.pusan.ac.kr/mod/zoom/loadmeeting.php?id=';
  static const String courseAutoAbsenceUrl = 'https://plato.pusan.ac.kr/local/ubattendance/autoattendance.php?id=';

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
    this.fontSize = 14.0,
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: AutoSizeText(
          text,
          minFontSize: fontSize,
          maxFontSize: fontSize,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
          overflowReplacement: Padding(
            padding: EdgeInsets.only(top: ((fontSize + 13.0) * MediaQuery.of(context).textScaleFactor - fontSize) / 2 - 4.0),
            child: Marquee(
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
        ),
      ),
    );
  }
}

Future<dio.Response?> requestGet(final String url, {dio.Options? options, required bool isFront, final int retry = 5}) async {
  dio.Response? response;
  int time = 0;

  options ??= dio.Options();
  options.headers ??= {};
  while (time < retry) {
    late final LoginInformation loginInformation;
    if (isFront == true) {
      await LoginController.to.login(autologin: true);
      loginInformation = LoginController.to.loginInformation;
    } else {
      //loginInformation = BackgroundLoginController.loginInformation;
      //loginInformation = await BackgroundLoginController.login(autologin: true);

      await BackgroundLoginController.login(autologin: true);
      loginInformation = BackgroundLoginController.loginInformation;
    }

    options.headers!["Cookie"] = loginInformation.moodleSessionKey;
    printLog("${options.headers!["Cookie"]}");

    try {
      response = await dio.Dio().get(url, options: options);
      if (parse(response.data).children[0].attributes['class'] == 'html_login') {
        time++;
        printLog("[RETRY] $retry");
      } else {
        break;
      }
    } on dio.DioError catch (e, stacktrace) {
      if (e.type == dio.DioErrorType.other) {
        return dio.Response(requestOptions: dio.RequestOptions(path: "null", data: stacktrace.toString()));
      } else {
        printLog("[ERROR] ${e.response}");
        time++;
      }
    }
  }
  return response;
}

Future<dio.Response?> requestPost(final String url, final dynamic data,
    {dio.Options? options, required final bool isFront, final int retry = 5}) async {
  dio.Response? response;
  int time = 0;

  options ??= dio.Options();
  options.headers ??= {};
  while (time < retry) {
    late final LoginInformation loginInformation;
    if (isFront == true) {
      await LoginController.to.login(autologin: true);
      loginInformation = LoginController.to.loginInformation;
    } else {
      //loginInformation = BackgroundLoginController.loginInformation;
      //loginInformation = await BackgroundLoginController.login(autologin: true);

      await BackgroundLoginController.login(autologin: true);
      loginInformation = BackgroundLoginController.loginInformation;
    }

    options.headers!["Cookie"] = loginInformation.moodleSessionKey;
    try {
      response = await dio.Dio().post(url, data: data, options: options);
      if (parse(response.data).children[0].attributes['class'] == 'html_login') {
        time++;
      } else {
        break;
      }
    } on dio.DioError catch (e, stacktrace) {
      if (e.type == dio.DioErrorType.other) {
        return dio.Response(requestOptions: dio.RequestOptions(path: "null", data: stacktrace.toString()));
      } else {
        printLog("[ERROR] ${e.response}");
        time++;
      }
    }
  }
  return response;
}

enum PlatoActionType { courseList }

Future<dio.Response?> requestAction(final PlatoActionType type, {required final bool isFront, final int retry = 5}) async {
  dio.Response? response;
  int time = 0;

  var options = dio.Options(
    contentType: 'application/x-www-form-urlencoded; charset=utf-8',
    headers: {"X-Requested-With": "XMLHttpRequest"},
  );
  while (time < retry) {
    late final LoginInformation loginInformation;
    if (isFront == true) {
      await LoginController.to.login(autologin: true);
      loginInformation = LoginController.to.loginInformation;
    } else {
      //loginInformation = BackgroundLoginController.loginInformation;
      //loginInformation = await BackgroundLoginController.login(autologin: true);

      await BackgroundLoginController.login(autologin: true);
      loginInformation = BackgroundLoginController.loginInformation;
    }

    options.headers!["Cookie"] = loginInformation.moodleSessionKey;
    String body = "sesskey=${LoginController.to.loginInformation.sessionKey}";
    switch (type) {
      case PlatoActionType.courseList:
        body += "&type=userInfoMy";
        break;
    }

    try {
      response = await dio.Dio().post("https://plato.pusan.ac.kr/theme/coursemosv2/action.php", data: body, options: options);

      if (response.data["code"] != "100") {
        time++;
      } else {
        break;
      }
    } on dio.DioError catch (e, stacktrace) {
      if (e.type == dio.DioErrorType.other) {
        return dio.Response(requestOptions: dio.RequestOptions(path: "null", data: stacktrace.toString()));
      } else {
        printLog("[ERROR] ${e.response}");
        time++;
      }
    }
  }
  return response;
}

Future<bool> openBrowser(final String url) async {
  final bool browserAvilable = await ChromeSafariBrowser.isAvailable();
  printLog(browserAvilable);
  if (browserAvilable == false) return false;
  ChromeSafariBrowser().open(
    url: Uri.parse(url),
    options: ChromeSafariBrowserClassOptions(
      android: AndroidChromeCustomTabsOptions(showTitle: false, toolbarBackgroundColor: Colors.white),
      ios: IOSSafariOptions(),
    ),
  );
  return true;
}

HtmlWidget renderHtml(String html) {
  return HtmlWidget(
    html,
    isSelectable: true,
    textStyle: const TextStyle(fontSize: 12),
    onTapUrl: (url) async {
      if (Uri.parse(url).scheme == 'https') {
        openBrowser(url);
      } else {
        launch(url);
      }
      return true;
    },
    customWidgetBuilder: (element) {
      if (element.classes.contains("badge")) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: const Color(0xff17a2b8)),
            child: Text(element.text, style: const TextStyle(color: Colors.white, fontSize: 11.0)),
          ),
        );
      }
      switch (element.localName) {
        case "video":
          return InnerPlayer(
            element.getElementsByTagName('source')[0].attributes["src"]!,
            headers: {"Cookie": LoginController.to.loginInformation.moodleSessionKey},
          );
        case "img":
          final String url = element.attributes["src"]!;
          printLog(url);

          return InkWell(
            onTap: () => Navigator.of(Get.context!, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => SafeArea(
                  child: PhotoView(
                    imageProvider: NetworkImage(
                      url,
                      headers: {
                        'Cookie': LoginController.to.loginInformation.moodleSessionKey,
                      },
                    ),
                  ),
                ),
              ),
            ),
            child: Image.network(
              url,
              headers: {
                'Cookie': LoginController.to.loginInformation.moodleSessionKey,
              },
            ),
          );
        case "table":
          final _scrollController = ScrollController();
          var tbody = element.getElementsByTagName('tbody')[0];
          var maxColumnLength = 0;
          for (var row in tbody.children) {
            maxColumnLength = max(maxColumnLength, row.children.length);
          }
          return Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  border: TableBorder.symmetric(inside: const BorderSide(color: Colors.grey)),
                  children: List.generate(
                    tbody.children.length,
                    (index) {
                      var row = tbody.children[index];
                      return TableRow(
                        children: List.generate(
                          maxColumnLength,
                          (index2) {
                            if (index2 >= row.children.length) {
                              return const TableCell(
                                child: Padding(padding: EdgeInsets.all(8.0), child: Text('')),
                              );
                            }
                            var column = row.children[index2];
                            return TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(column.text),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
      }
      return null;
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

Future<BuildContext> showProgressDialog(final BuildContext context, final String msg) async {
  final dialogContextCompleter = Completer<BuildContext>();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      dialogContextCompleter.complete(context);
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 5),
              Text(msg),
            ],
          ),
        ),
      );
    },
  );

  return await dialogContextCompleter.future;
}

void closeProgressDialog(BuildContext context) {
  Navigator.pop(context);
}

class BetaBadge extends StatelessWidget {
  final Widget child;
  const BetaBadge({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -10,
          child: Transform.rotate(
            angle: 45 * pi / 180,
            child: const Text("Beta", style: TextStyle(backgroundColor: Colors.red)),
          ),
        ),
      ],
    );
  }
}
