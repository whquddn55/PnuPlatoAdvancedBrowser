import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';

part 'assign_todo.g.dart';

@HiveType(typeId: 0)
class AssignTodo extends Todo {
  AssignTodo({
    required int index,
    required String id,
    required String title,
    required String courseId,
    required DateTime dueDate,
    required bool availability,
    required String iconUrl,
    required TodoStatus status,
  }) : super(
          index: index,
          id: id,
          title: title,
          courseId: courseId,
          dueDate: dueDate,
          availability: availability,
          iconUrl: iconUrl,
          status: status,
        );

  @override
  Color getColor() => assignColor;
}
