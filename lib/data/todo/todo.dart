import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/quiz_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/unknown_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

enum TodoStatus { done, undone, doing }

abstract class Todo {
  final String id;
  final String title;
  final String courseId;
  final DateTime dueDate;
  final bool availability;
  final Uri iconUri;
  TodoStatus status;

  Todo({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    required this.availability,
    required this.iconUri,
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

  static Todo fromJson(Map<String, dynamic> json) {
    switch (json["type"]) {
      case "quiz":
        return QuizTodo(
            id: json["id"],
            title: json["title"],
            courseId: json["courseId"],
            dueDate: DateTime.parse(json["dueDate"]),
            availability: json["availability"],
            iconUri: Uri.parse(json["iconUri"]),
            status: TodoStatus.values.byName(json["status"]));
      case "vod":
        return VodTodo(
            id: json["id"],
            title: json["title"],
            courseId: json["courseId"],
            dueDate: DateTime.parse(json["dueDate"]),
            availability: json["availability"],
            iconUri: Uri.parse(json["iconUri"]),
            status: TodoStatus.values.byName(json["status"]));
      case "zoom":
        return ZoomTodo(
            id: json["id"],
            title: json["title"],
            courseId: json["courseId"],
            dueDate: DateTime.parse(json["dueDate"]),
            availability: json["availability"],
            iconUri: Uri.parse(json["iconUri"]),
            status: TodoStatus.values.byName(json["status"]));
      case "assign":
        return AssignTodo(
            id: json["id"],
            title: json["title"],
            courseId: json["courseId"],
            dueDate: DateTime.parse(json["dueDate"]),
            availability: json["availability"],
            iconUri: Uri.parse(json["iconUri"]),
            status: TodoStatus.values.byName(json["status"]));
      default:
        return UnknownTodo(
            id: json["id"],
            title: json["title"],
            courseId: json["courseId"],
            dueDate: DateTime.parse(json["dueDate"]),
            availability: json["availability"],
            iconUri: Uri.parse(json["iconUri"]),
            status: TodoStatus.values.byName(json["status"]));
    }
  }

  Map<String, dynamic> toJson() {
    String typeString = "unknown";
    switch (runtimeType) {
      case QuizTodo:
        typeString = "quiz";
        break;
      case VodTodo:
        typeString = "vod";
        break;
      case ZoomTodo:
        typeString = "zoom";
        break;
      case AssignTodo:
        typeString = "assign";
        break;
      case UnknownTodo:
        typeString = "unkown";
        break;
    }
    return {
      "id": id,
      "title": title,
      "courseId": courseId,
      "dueDate": dueDate.toString(),
      "type": typeString,
      "availability": availability,
      "iconUri": iconUri.toString(),
      "status": status.name,
    };
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
