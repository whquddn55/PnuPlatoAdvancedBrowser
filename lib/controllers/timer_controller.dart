import 'dart:async';

import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';

abstract class TimerController {
  static Timer? _timer;
  static bool _lock = false;

  static void initialize() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_lock == true) return;
      await _updateTodoStatus();
    });
  }

  static Future<void> _updateTodoStatus() async {
    _lock = true;
    bool updated = false;
    Set<String> courseIdSet = <String>{};
    final now = DateTime.now();
    for (var todo in TodoController.to.todoList) {
      if (todo.userDefined == false && todo.checked == false) {
        if (now.compareTo(todo.dueDate ?? now) == 1) {
          /* DueDate가 지나면 Update */
          todo.checked = true;
          updated = true;
          courseIdSet.add(todo.courseId);
        }
      } else if (todo.runtimeType == ZoomTodo &&
          todo.userDefined == false &&
          todo.status == TodoStatus.doing &&
          now.difference(todo.dueDate ?? now) >= const Duration(hours: 1)) {
        /* DueDate에서 1시간이 지난 Zoom강의는 자동으로 done상태로 전환 */
        todo.status = TodoStatus.done;
        updated = true;
      }
    }
    if (updated) {
      TodoController.to.storeTodoList();
      await TodoController.to.fetchTodoList(courseIdSet.toList());
    }
    _lock = false;
  }
}
