import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/quiz_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/unknown_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';

abstract class HiveController {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    /* register HiveAdapters */
    Hive.registerAdapter(TodoStatusAdapter());
    Hive.registerAdapter(AssignTodoAdapter());
    Hive.registerAdapter(QuizTodoAdapter());
    Hive.registerAdapter(UnknownTodoAdapter());
    Hive.registerAdapter(VodTodoAdapter());
    Hive.registerAdapter(ZoomTodoAdapter());
  }

  static Future<List<Todo>> loadTodoList() async {
    final box = await Hive.openBox("userData");
    final res = List<Todo>.from(box.get("todoList") ?? []);
    await box.close();
    return res;
  }

  static Future<void> storeTodoList(final List<Todo> todoList) async {
    final box = await Hive.openBox("userData");
    await box.put("todoList", todoList);
    await box.close();
  }
}
