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
