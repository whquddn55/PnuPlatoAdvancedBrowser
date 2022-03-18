import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

class TodoController extends GetxController {
  static TodoController get to => Get.find<TodoController>();
  static final Set<String> _refreshLock = {};
  List<Todo> _todoList = <Todo>[];

  List<Todo> get todoList {
    final userDefinedList = _todoList.where((todo) => todo.userDefined == true);
    var res = _todoList
        .where((todo) =>
            todo.userDefined == true ||
            userDefinedList.any((element) => (element.courseId + element.type + element.id + "false").hashCode == todo.dbId) == false)
        .toList();
    return res;
  }

  Future<void> initialize() async {
    _todoList = StorageController.loadTodoList();
  }

  Future<void> refreshTodoListAll() async {
    var courseIdList = CourseController.currentSemesterCourseList.map((course) => course.id).toList();

    await refreshTodoList(courseIdList);
  }

  Future<void> refreshTodoList(List<String> courseIdList) async {
    /* 중복 업데이트 방지 Lock */
    courseIdList = _lockCourseId(courseIdList);
    if (courseIdList.isEmpty) return;

    await BackgroundService.sendData(
      BackgroundServiceAction.fetchTodoList,
      data: {"courseIdList": courseIdList},
    );
    _todoList = StorageController.loadTodoList();
    update();

    /* unlock */
    _unlockCourseId();
  }

  Future<void> updateVodTodoStatus(final String courseId, final Map<int, List<Map<String, dynamic>>> vodStatusMap) async {
    bool modified = false;
    for (var todo in _todoList) {
      for (var vodStatusList in vodStatusMap.values) {
        for (var vodStatus in vodStatusList) {
          if (todo.runtimeType == (VodTodo) && todo.userDefined == false && todo.courseId == courseId && todo.title == vodStatus["title"]) {
            if (todo.status != vodStatus["status"]) {
              modified = true;
              todo.status = vodStatus["status"] == true ? TodoStatus.done : TodoStatus.undone;
            }
          }
        }
      }
    }

    if (modified) {
      StorageController.storeTodoList(_todoList);
      update();
    }
  }

  Future<void> updateZoomTodoStatus(final String id, final TodoStatus status) async {
    bool modified = false;
    for (var todo in _todoList) {
      if (todo.runtimeType == (ZoomTodo) && todo.userDefined == false && todo.id == id) {
        if (todo.status != status) {
          modified = true;
          todo.status = status;
        }
      }
    }

    if (modified) {
      StorageController.storeTodoList(_todoList);
      update();
    }
  }

  Future<void> updateAssignTodoStatus(final String id, final TodoStatus status) async {
    bool modified = false;
    for (var todo in _todoList) {
      if (todo.runtimeType == (AssignTodo) && todo.userDefined == false && todo.id == id) {
        if (todo.status == status) {
          modified = true;
          todo.status = status;
        }
      }
    }

    if (modified) {
      StorageController.storeTodoList(_todoList);
      update();
    }
  }

  Future<void> changeTodoStatus(final BuildContext context, final Todo target) async {
    var res = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: target.userDefined == true ? const Text("상태를 복구합니다.") : const Text("상태를 변경합니다."),
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

    if (res == true) {
      if (target.userDefined == false) {
        final newTodo = Todo(
          availability: target.availability,
          courseId: target.courseId,
          dueDate: target.dueDate ?? DateTime.now(),
          iconUrl: target.iconUrl,
          id: target.id,
          index: target.index,
          statusIndex: target.status == TodoStatus.done ? TodoStatus.undone.index : TodoStatus.done.index,
          title: target.title,
          type: target.type,
          userDefined: true,
        ).transType();
        _todoList.insert(_todoList.indexOf(target), newTodo);
      } else {
        _todoList.remove(target);
      }
      StorageController.storeTodoList(_todoList);
      update();
    }
  }

  // Future<void> _updateTodoList(final List<Todo> newTodoList) async {
  //   bool updated = false;
  //   var candidateList = [];
  //   for (var newTodo in newTodoList) {
  //     var sameTodo = todoList.firstWhereOrNull((todo) => todo == newTodo);
  //     if (sameTodo == null) {
  //       updated = true;
  //       candidateList.add(newTodo);
  //     } else if (!(newTodo.availability == newTodo.availability &&
  //         newTodo.dueDate == newTodo.dueDate &&
  //         newTodo.iconUri == newTodo.iconUri &&
  //         newTodo.title == newTodo.title &&
  //         newTodo.status == newTodo.status)) {
  //       updated = true;
  //       todoList.remove(sameTodo);
  //       candidateList.add(newTodo);
  //     }
  //   }

  //   if (updated) {
  //     for (var candidate in candidateList) {
  //       todoList.add(candidate);
  //     }
  //     update();

  //     Fluttertoast.cancel();
  //     Fluttertoast.showToast(msg: "캘린더가 업데이트 되었습니다.");
  //   }
  // }

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
}
