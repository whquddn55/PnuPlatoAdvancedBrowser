import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
part 'vod_todo.g.dart';

@HiveType(typeId: 3)
class VodTodo extends Todo {
  VodTodo(
      {required int index,
      required String id,
      required String title,
      required String courseId,
      required DateTime dueDate,
      required bool availability,
      required String iconUrl,
      required TodoStatus status})
      : super(
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
  Color getColor() => vodColor;
}
