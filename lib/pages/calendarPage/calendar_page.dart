import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          onRefresh: () async => await TodoController.to.refreshTodoListAll(),
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
