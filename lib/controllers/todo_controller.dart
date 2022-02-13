import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/data/todo.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

class TodoController extends GetxController {
  List<Todo> todoList = <Todo>[];

  Future<void> updateTodoList(final List<String> courseIdList, final List<Map<String, dynamic>> vodStatusList) async {
    todoList = List<Todo>.from(await BackgroundService.sendData(
      BackgroundServiceAction.fetchTodoList,
      data: {
        "courseIdList": courseIdList,
        "vodStatusList": vodStatusList,
      },
    ));

    update();
  }
}
