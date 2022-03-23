import 'dart:async';

import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';

abstract class TimerController {
  static late final Timer _timer;

  static void initialize() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {});
  }

  static Future<void> updateTodoStatus() async {
    bool updated = false;
    Set<String> courseIdSet = <String>{};
    final now = DateTime.now();
    for (var todo in TodoController.to.todoList) {
      if (todo.userDefined == false && todo.checked == false) {
        if (now.compareTo(todo.dueDate ?? now) == 1) {
          todo.checked = true;
          updated = true;
          courseIdSet.add(todo.courseId);
        }
      }
    }
    if (updated) {
      TodoController.to.storeTodoList();
      await TodoController.to.refreshTodoList(courseIdSet.toList());
    }
  }
}
