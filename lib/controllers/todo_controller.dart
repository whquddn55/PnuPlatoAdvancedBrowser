import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_assign_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_zoom_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_assign.dart';
import 'package:pnu_plato_advanced_browser/data/course_zoom.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

class TodoController extends GetxController {
  static TodoController get to => Get.find<TodoController>();

  final RxBool progress = false.obs;
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
    ever(progress, (progressStatus) async {
      if (progressStatus == true) {
        await Fluttertoast.cancel();
        await Fluttertoast.showToast(msg: "캘린더 동기화 중입니다...", backgroundColor: Colors.black.withOpacity(0.2));
      }
    });
  }

  void storeTodoList() {
    StorageController.storeTodoList(_todoList);
    update();
  }

  Future<void> refreshTodoListAll() async {
    await BackgroundService.sendData(BackgroundServiceAction.fetchTodoListAll);
  }

  Future<void> refreshTodoList(List<String> courseIdList) async {
    progress.value = true;

    await BackgroundService.sendData(
      BackgroundServiceAction.fetchTodoList,
      data: {"courseIdList": courseIdList},
    );
    _todoList = StorageController.loadTodoList();
    update();

    progress.value = false;
  }

  Future<Map<int, List<Map<String, dynamic>>>> updateVodTodoStatus(final String courseId) async {
    final Map<int, List<Map<String, dynamic>>> vodStatusMap = await CourseController.getVodStatus(courseId, true);
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
      storeTodoList();
    }
    return vodStatusMap;
  }

  Future<CourseZoom?> updateZoomTodoStatus(final String id) async {
    final CourseZoom? zoom = await CourseZoomController.fetchCourseZoom(id);
    if (zoom == null) return null;

    final TodoStatus status = zoom.status;
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
      storeTodoList();
    }
    return zoom;
  }

  Future<CourseAssign?> updateAssignTodoStatus(final String id) async {
    final CourseAssign? assign = await CourseAssignController.fetchCourseAssign(id);
    if (assign == null) return null;

    final TodoStatus status = assign.submitted == true ? TodoStatus.done : TodoStatus.undone;
    bool modified = false;
    for (var todo in _todoList) {
      if (todo.runtimeType == (AssignTodo) && todo.userDefined == false && todo.id == id) {
        if (todo.status != status) {
          modified = true;
          todo.status = status;
        }
      }
    }

    if (modified) {
      storeTodoList();
    }
    return assign;
  }

  void changeTodoStatus(final BuildContext context, final Todo target) async {
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
          checked: target.checked,
        ).transType();
        _todoList.insert(_todoList.indexOf(target), newTodo);
      } else {
        _todoList.remove(target);
      }
      storeTodoList();
    }
  }
}
