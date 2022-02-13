import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
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
      body: GetBuilder<LoginController>(
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GetBuilder<TodoController>(
                      builder: (controller) {
                        return MainCalendar(controller.todoList);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
