import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

class TodoController extends GetxController {
  static TodoController get to => Get.find<TodoController>();
  static final Set<String> _refreshLock = {};
  List<Todo> todoList = <Todo>[];

  Future<void> initialize() async {
    todoList = await StorageController.loadTodoList();
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
    todoList = await StorageController.loadTodoList();
    update();

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
      await StorageController.storeTodoList(todoList);
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
