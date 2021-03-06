import 'dart:ui';

import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';

class UnknownTodo extends Todo {
  UnknownTodo({
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
          id: id,
          title: title,
          courseId: courseId,
          dueDate: dueDate,
          availability: availability,
          iconUrl: iconUrl,
          statusIndex: status.index,
          type: "unknown",
          userDefined: userDefined,
          checked: checked,
        );

  @override
  Color getColor() => AppSettingController.to.unknownColor;
}
