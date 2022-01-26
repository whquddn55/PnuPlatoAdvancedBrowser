import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/academic_calendar_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/data/acamedic_calendar_item.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/academic_calendar.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/main_calendar.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/sections/drawer.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('캘린더'),
        centerTitle: true,
      ),
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
            return FutureBuilder(
                future: AcademicCalendarController.getAcademicCalendar(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data as List<AcademicCalendarItem>;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          AcademicCalendar(itemList: data),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MainCalendar(),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const LoadingPage(msg: '캘린더를 불러오는 중입니다...');
                  }
                });
          }
        },
      ),
    );
  }
}
