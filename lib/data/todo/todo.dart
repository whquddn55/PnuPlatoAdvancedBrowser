import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/quiz_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/unknown_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

part 'todo.g.dart';

enum TodoStatus { done, undone, doing }

class TodoStatusConverter extends TypeConverter<TodoStatus, int> {
  const TodoStatusConverter(); // Converters need to have an empty const constructor

  @override
  TodoStatus fromIsar(int object) {
    return TodoStatus.values[object];
  }

  @override
  int toIsar(TodoStatus object) {
    return object.index;
  }
}

@Collection()
class Todo {
  @Id()
  int? isarId;

  final int index;
  final String id;
  final String title;
  final String courseId;
  final DateTime? dueDate;
  final bool availability;
  final String iconUrl;
  final String type;
  @TodoStatusConverter()
  TodoStatus status;

  Todo({
    this.isarId,
    required this.index,
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    required this.availability,
    required this.iconUrl,
    required this.status,
    required this.type,
  });

  Todo transType() {
    switch (type) {
      case "assign":
        return AssignTodo(
            isarId: isarId,
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            index: index,
            status: status,
            title: title);
      case "quiz":
        return QuizTodo(
            isarId: isarId,
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            index: index,
            status: status,
            title: title);
      case "vod":
        return VodTodo(
            isarId: isarId,
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            index: index,
            status: status,
            title: title);
      case "zoom":
        return ZoomTodo(
            isarId: isarId,
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            index: index,
            status: status,
            title: title);
      default:
        return UnknownTodo(
            isarId: isarId,
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            index: index,
            status: status,
            title: title);
    }
  }

  @override
  int get hashCode => (courseId + type + id).hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    var otherTodo = other as Todo;
    return otherTodo.hashCode == hashCode;
  }

  void open(final BuildContext context) {
    var course = CourseController.getCourseById(courseId);
    if (course == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ErrorPage(msg: "없는... 강의인데요??")));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course, targetActivityId: id)));
  }

  Color getColor() {
    throw UnimplementedError("getcolor on todo");
  }
}
