import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/timer_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
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
                if (snapshot.connectionState != ConnectionState.done) return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: 'DB동기화 중...'));

                WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
                  if (StorageController.loadLastTodoSyncTime() == DateTime(2000)) {
                    await showProgressDialog(context, "앱 초기화 작업 중입니다...\n약간의 시간이 소요됩니다.").then((progressContext) async {
                      await NotificationController.fetchNotificationList(enableNotify: false);
                      await TodoController.to.fetchTodoListAll().then((_) {
                        closeProgressDialog(progressContext);
                      });
                    });
                  }
                  TimerController.initialize();
                });

                return const NavigatorBody();
              },
            );
          },
        );
      },
    );
  }
}
