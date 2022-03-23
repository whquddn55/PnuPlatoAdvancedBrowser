import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';

class AppBarWrapper extends AppBar {
  AppBarWrapper({Key? key, final String? title, final PreferredSizeWidget? bottom, final Widget? leading, final List<Widget>? actions})
      : super(
          key: key,
          elevation: 0.0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Visibility(
                  child: const SizedBox(height: 10, width: 10, child: CircularProgressIndicator(strokeWidth: 2)),
                  visible: TodoController.to.progress.value)),
              const SizedBox(width: 5),
              Flexible(child: Text(title ?? "", overflow: TextOverflow.fade)),
            ],
          ),
          centerTitle: true,
          leading: leading,
          actions: actions,
        );
}
