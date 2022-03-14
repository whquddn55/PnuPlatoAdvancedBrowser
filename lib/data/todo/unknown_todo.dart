import 'dart:ui';

import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';

class UnknownTodo extends Todo {
  UnknownTodo(
      {required int index,
      required String id,
      required String title,
      required String courseId,
      required DateTime dueDate,
      required bool availability,
      required Uri iconUri,
      required TodoStatus status})
      : super(
          index: index,
          id: id,
          title: title,
          courseId: courseId,
          dueDate: dueDate,
          availability: availability,
          iconUri: iconUri,
          status: status,
        );

  @override
  Color getColor() => unknownColor;
}
