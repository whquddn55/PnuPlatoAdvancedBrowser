import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/quiz_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/unknown_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

import '../../objectbox.g.dart';

enum TodoStatus { done, undone, doing }

@Entity()
class Todo {
  @Id(assignable: true)
  int dbId;

  final String id;
  final String title;
  final String courseId;
  final DateTime? dueDate;
  final bool availability;
  final String iconUrl;
  final String type;
  int statusIndex;
  TodoStatus _status;
  final bool userDefined;
  bool checked = false;

  Todo({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    required this.availability,
    required this.iconUrl,
    required this.type,
    required this.statusIndex,
    required this.userDefined,
    required this.checked,
  })  : dbId = (courseId + type + id + userDefined.toString()).hashCode,
        _status = TodoStatus.values[statusIndex];

  Todo transType() {
    TodoStatus status = TodoStatus.values[statusIndex];
    switch (type) {
      case "assign":
        return AssignTodo(
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            status: status,
            title: title,
            userDefined: userDefined, checked:checked,);
      case "quiz":
        return QuizTodo(
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            status: status,
            title: title,
            userDefined: userDefined, checked:checked,);
      case "vod":
        return VodTodo(
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            status: status,
            title: title,
            userDefined: userDefined, checked:checked,);
      case "zoom":
        return ZoomTodo(
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            status: status,
            title: title,
            userDefined: userDefined, checked:checked,);
      default:
        return UnknownTodo(
            availability: availability,
            courseId: courseId,
            dueDate: dueDate,
            iconUrl: iconUrl,
            id: id,
            status: status,
            title: title,
            userDefined: userDefined, checked:checked,);
    }
  }

  TodoStatus get status => _status;
  set status(TodoStatus status) {
    _status = status;
    statusIndex = TodoStatus.values.indexOf(status);
  }

  @override
  int get hashCode => dbId;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other.hashCode == hashCode;
  }

  void open(final BuildContext context) {
    var course = CourseController.getCourseById(courseId);
    if (course == null) {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const ErrorPage(msg: "없는... 강의인데요??")));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course, targetActivityId: id)));
  }

  Color getColor() {
    throw UnimplementedError("getcolor on todo");
  }
}
