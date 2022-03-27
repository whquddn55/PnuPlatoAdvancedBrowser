import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/academic_calendar.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/main_calendar.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/login_builder_page.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar("캘린더"),
      drawer: const MainDrawer(),
      body: LoginBuilderPage(
        () => RefreshIndicator(
          onRefresh: () async {
            bool selectResult = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: const Text("모든 강의의 할일을 동기화 합니다.\n약 1분의 시간이 소요됩니다."),
                actions: [
                  TextButton(
                    child: const Text("취소"),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  TextButton(
                    child: const Text("확인"),
                    onPressed: () => Navigator.pop(context, true),
                  )
                ],
              ),
            );
            if (selectResult == true) {
              await showProgressDialog(context, "앱 동기화 중입니다...\n약간의 시간이 소요됩니다.").then((progressContext) async {
                await TodoController.to.fetchTodoListAll().then((_) {
                  closeProgressDialog(progressContext);
                });
              });
            }
          },
          child: ListView(
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
        ),
      ),
    );
  }
}
