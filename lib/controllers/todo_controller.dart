import 'dart:convert';

import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/data/todo.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoController extends GetxController {
  List<Todo> todoList = <Todo>[];

  Future<void> initiate() async {
    final preference = await SharedPreferences.getInstance();
    todoList = List<Map<String, dynamic>>.from(jsonDecode(preference.getString("todoList") ?? "[]")).map<Todo>((m) => Todo.fromJson(m)).toList();
  }

  Future<void> refreshTodoList(final List<String> courseIdList, final List<Map<String, dynamic>> vodStatusList) async {
    todoList = List<Todo>.from(await BackgroundService.sendData(
      BackgroundServiceAction.fetchTodoList,
      data: {
        "courseIdList": courseIdList,
        "vodStatusList": vodStatusList,
      },
    ));

    final preference = await SharedPreferences.getInstance();
    preference.setString("todoList", jsonEncode(todoList));

    update();
  }

  void updateTodoStatus(final Map<int, List<Map<String, dynamic>>> vodStatusMap) async {
    bool modified = false;
    for (var todo in todoList) {
      for (var vodStatusList in vodStatusMap.values) {
        for (var vodStatus in vodStatusList) {
          if (todo.title == vodStatus["title"]) {
            if (todo.status != vodStatus["status"]) {
              modified = true;
              todo.status = vodStatus["status"] == true ? TodoStatus.done : TodoStatus.undone;
            }
          }
        }
      }
    }

    if (modified) {
      final preference = await SharedPreferences.getInstance();
      preference.setString("todoList", jsonEncode(todoList));
      update();
    }
  }

  // void updateTodoList(final List<CourseActivity> activityList) {
  //   bool modified = false;
  //   for (var activity in activityList) {
  //     final int index = TodoType.values.indexWhere((element) => element.name == activity.type);
  //     if (index == -1) continue;

  //     bool isIn = false;
  //     for (var todo in todoList) {
  //       if (todo.title == activity.title && todo.courseId == activity.courseId) {
  //         isIn = true;
  //       }
  //     }

  //     if (!isIn) {
  //       todoList.add(Todo(
  //         id: activity.id,
  //         title: activity.title,
  //         courseId: activity.courseId,
  //         dueDate: activity.endDate!,
  //         type: TodoType.values[index],
  //         availability: activity.availablility,
  //         iconUri: activity.iconUri!,
  //         status: TodoStatus.undone,
  //       ));
  //       modified = true;
  //     }
  //   }

  //   if (modified) update();
  // }
}
