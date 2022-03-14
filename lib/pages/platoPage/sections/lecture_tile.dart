import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/quiz_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

class LectureTile extends StatelessWidget {
  final Course course;

  const LectureTile({
    Key? key,
    required this.course,
  }) : super(key: key);

  Widget _renderTodoCnt() {
    return GetBuilder<TodoController>(
      builder: (controller) {
        int totalVodCnt = 0;
        int undoneVodCnt = 0;
        int totalAssignCnt = 0;
        int undoneAssignCnt = 0;
        int totalZoomCnt = 0;
        int undoneZoomCnt = 0;

        for (var todo in controller.todoList) {
          if (todo.courseId == course.id) {
            switch (todo.runtimeType) {
              case AssignTodo:
              case QuizTodo:
                totalAssignCnt++;
                if (todo.status != TodoStatus.done) undoneAssignCnt++;
                break;
              case VodTodo:
                totalVodCnt++;
                if (todo.status != TodoStatus.done) undoneVodCnt++;
                break;
              case ZoomTodo:
                totalZoomCnt++;
                if (todo.status != TodoStatus.done) undoneZoomCnt++;
                break;
            }
          }
        }

        return Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: vodColor,
                    ),
                  ),
                  Text('$undoneVodCnt / $totalVodCnt', style: TextStyle(color: undoneVodCnt == 0 ? Colors.grey : Colors.red)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: assignColor,
                    ),
                  ),
                  Text('$undoneAssignCnt / $totalAssignCnt', style: TextStyle(color: undoneAssignCnt == 0 ? Colors.grey : Colors.red)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: zoomColor,
                    ),
                  ),
                  Text('$undoneZoomCnt / $totalZoomCnt', style: TextStyle(color: undoneZoomCnt == 0 ? Colors.grey : Colors.red)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course))),
        borderRadius: BorderRadius.circular(30.0),
        child: Ink(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(color: const Color(0xffdddddd), borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("${course.title} [${course.sub}]"),
              _renderTodoCnt(),
            ],
          ),
        ),
      ),
    );
  }
}
