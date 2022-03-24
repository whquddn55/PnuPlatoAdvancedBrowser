import 'dart:ui';

import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';

class ZoomTodo extends Todo {
  ZoomTodo({
    required int index,
    required String id,
    required String title,
    required String courseId,
    required DateTime? dueDate,
    required bool availability,
    required String iconUrl,
    required TodoStatus status,
    required bool userDefined,
    required bool checked,
  }) : super(
          index: index,
          id: id,
          title: title,
          courseId: courseId,
          dueDate: dueDate,
          availability: availability,
          iconUrl: iconUrl,
          statusIndex: status.index,
          type: "zoom",
          userDefined: userDefined,
          checked: checked,
        );

  @override
  Color getColor() => zoomColor;
}
