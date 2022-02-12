import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/academic_calendar.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/main_calendar.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar("캘린더"),
      drawer: const MainDrawer(),
      body: GetBuilder<UserDataController>(
        builder: (controller) {
          if (controller.loginStatus == false) {
            return Builder(builder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const Center(
                    child: Text(
                  '로그인이 필요합니다.',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                )),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            });
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const AcademicCalendar(),
                  // Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: StreamBuilder<Map<String, dynamic>?>(
                  //         stream: BackgroundService.service.onDataReceived,
                  //         builder: (context, snapshot) {
                  //           if (!snapshot.hasData) {
                  //             return const LoadingPage(msg: "데이터를 불러오는 중입니다...");
                  //           }
                  //           return MainCalendar(snapshot.data!["todoList"]);
                  //         })),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
