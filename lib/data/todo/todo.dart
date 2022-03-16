import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

part 'todo.g.dart';

@HiveType(typeId: 5)
enum TodoStatus {
  @HiveField(0)
  done,
  @HiveField(1)
  undone,
  @HiveField(2)
  doing
}

abstract class Todo {
  @HiveField(0)
  final int index;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String courseId;
  @HiveField(4)
  final DateTime? dueDate;
  @HiveField(5)
  final bool availability;
  @HiveField(6)
  final String iconUrl;
  @HiveField(7)
  TodoStatus status;

  Todo({
    required this.index,
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    required this.availability,
    required this.iconUrl,
    required this.status,
  });

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    var otherTodo = other as Todo;
    return otherTodo.id == id && otherTodo.courseId == courseId;
  }

  void open(final BuildContext context) {
    var course = CourseController.getCourseById(courseId);
    if (course == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ErrorPage(msg: "없는... 강의인데요??")));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course, targetActivityId: id)));
  }

  Color getColor();
}
