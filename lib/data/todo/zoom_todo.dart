import 'dart:ui';

import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';

class ZoomTodo extends Todo {
  ZoomTodo({
    int? isarId,
    required int index,
    required String id,
    required String title,
    required String courseId,
    required DateTime? dueDate,
    required bool availability,
    required String iconUrl,
    required TodoStatus status,
  }) : super(
          isarId: isarId,
          index: index,
          id: id,
          title: title,
          courseId: courseId,
          dueDate: dueDate,
          availability: availability,
          iconUrl: iconUrl,
          status: status,
          type: "zoom",
        );

  @override
  Color getColor() => zoomColor;
}
