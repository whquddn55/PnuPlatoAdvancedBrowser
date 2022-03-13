import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoController extends GetxController {
  static TodoController get to => Get.find<TodoController>();
  static final Set<String> _refreshLock = {};
  List<Todo> todoList = <Todo>[];

  Future<void> initiate() async {
    final preference = await SharedPreferences.getInstance();
    todoList = List<Map<String, dynamic>>.from(jsonDecode(preference.getString("todoList") ?? "[]")).map<Todo>((m) => Todo.fromJson(m)).toList();
  }

  Future<void> refreshTodoListAll() async {
    var courseIdList = CourseController.currentSemesterCourseList.map((course) => course.id).toList();

    await refreshTodoList(courseIdList);
  }

  Future<void> refreshTodoList(List<String> courseIdList) async {
    /* 중복 업데이트 방지 Lock */
    courseIdList = _lockCourseId(courseIdList);
    if (courseIdList.isEmpty) return;

    var newTodoList = await BackgroundService.sendData(
      BackgroundServiceAction.fetchTodoList,
      data: {"courseIdList": courseIdList},
    );
    await _updateTodoList(List<Todo>.from(newTodoList));

    /* unlock */
    _unlockCourseId();
  }

  Future<void> updateTodoStatus(final Map<int, List<Map<String, dynamic>>> vodStatusMap) async {
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

  Future<void> _updateTodoList(final List<Todo> newTodoList) async {
    bool updated = false;
    var candidateList = [];
    for (var newTodo in newTodoList) {
      var sameTodo = todoList.firstWhereOrNull((todo) => todo == newTodo);
      if (sameTodo == null) {
        updated = true;
        candidateList.add(newTodo);
      } else if (!(newTodo.availability == newTodo.availability &&
          newTodo.dueDate == newTodo.dueDate &&
          newTodo.iconUri == newTodo.iconUri &&
          newTodo.title == newTodo.title &&
          newTodo.status == newTodo.status)) {
        updated = true;
        todoList.remove(sameTodo);
        candidateList.add(newTodo);
      }
    }

    if (updated) {
      for (var candidate in candidateList) {
        todoList.add(candidate);
      }
      update();

      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: "캘린더가 업데이트 되었습니다.");
    }
  }

  List<String> _lockCourseId(List<String> courseIdList) {
    return courseIdList.where((courseId) {
      bool res = _refreshLock.contains(courseId) == false;
      _refreshLock.add(courseId);
      return res;
    }).toList();
  }

  void _unlockCourseId() {
    _refreshLock.clear();
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
