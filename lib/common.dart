import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';

class CommonUrl {
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

  static const String academicCalendarUrl = 'https://www.pusan.ac.kr/kor/CMS/Haksailjung/PopupView.do';
  static const String findIdUrl = 'https://u-pip.pusan.ac.kr/rSSO/popup/FindID_step1.asp';
  static const String findPwUrl = 'https://u-pip.pusan.ac.kr/rSSO/popup/FindPassword_step1.asp';
}

Future<Dio.Response?> request(String url, {Dio.Options? options, Function? callback}) async {
  Dio.Response? response;
  int retry = 0;
  while (retry < 5) {
    try {
      response = await Dio.Dio().get(url, options: options);
      if (parse(response.data).children[0].attributes['class'] == 'html_login') {
        retry++;
        if (callback != null) {
          await callback();
        }
      } else {
        break;
      }
    } on Dio.DioError catch (e, _) {
      retry++;
    }
  }
  return response;
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
