import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/sections/navigator_body.dart';

class NavigatorPage extends StatelessWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _loginFuture = Get.find<LoginController>().login(autologin: true);

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

    return FutureBuilder<void>(
      future: _loginFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: '로그인 중...'));
        }

        String? studentId;

        if (LoginController.to.loginInformation.loginStatus == true) {
          LoginController.to.loginInformation.studentId;
        }

        return FutureBuilder<void>(
          future: _dbInitFuture(studentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: 'DB 접속 중...'));
            }

            return const NavigatorBody();
          },
        );
      },
    );
  }
}
