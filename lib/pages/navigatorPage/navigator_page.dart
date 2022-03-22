import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/sections/navigator_body.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

class NavigatorPage extends StatelessWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _dbInitFuture(final String? studentId) async {
      if (studentId == null) {
        return;
      }
      var doc = await FirebaseFirestore.instance.collection("users").doc(studentId).get();

      if (doc.exists == false) {
        await FirebaseFirestore.instance.collection("users").doc(studentId).set({
          "unread": 0,
          "adminUnread": 0,
          "time": Timestamp.now(),
          "readList": [],
        });
      }
    }

    return FutureBuilder(
      future: LoginController.to.login(autologin: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: '로그인 중...'));
        }
        return GetBuilder<LoginController>(
          builder: (contoller) {
            if (LoginController.to.loginInformation.loginStatus != true) {
              return const NavigatorBody();
            }

            /* 로그인 성공, 앱 init 작업 시작 */

            final String studentId = LoginController.to.loginInformation.studentId;
            return FutureBuilder<void>(
              future:
                  Future.wait([_dbInitFuture(studentId), BackgroundService.initializeService(), CourseController.updateCurrentSemesterCourseList()]),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: 'DB 접속 중...'));
                }

                return const NavigatorBody();
              },
            );
          },
        );
      },
    );
  }
}
