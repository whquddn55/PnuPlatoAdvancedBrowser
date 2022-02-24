import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/data/todo.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

class LectureTile extends StatelessWidget {
  final Color videoColor = Colors.blue;
  final Color assignColor = Colors.red;
  final Color zoomColor = Colors.green;
  final Course course;

  const LectureTile({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course))),
        borderRadius: BorderRadius.circular(30.0),
        child: Ink(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 15.0,
                offset: const Offset(0, 0.75), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${course.title} [${course.sub}]"),
              GetBuilder<TodoController>(
                builder: (controller) {
                  int totalVodCnt = 0;
                  int undoneVodCnt = 0;
                  int totalAssignCnt = 0;
                  int undoneAssignCnt = 0;
                  int totalZoomCnt = 0;
                  int undoneZoomCnt = 0;

                  for (var todo in controller.todoList) {
                    if (todo.courseId == course.id) {
                      switch (todo.type) {
                        case TodoType.assign:
                        case TodoType.quiz:
                          totalAssignCnt++;
                          if (todo.status != TodoStatus.done) undoneAssignCnt++;
                          break;
                        case TodoType.vod:
                          totalVodCnt++;
                          if (todo.status != TodoStatus.done) undoneVodCnt++;
                          break;
                        case TodoType.zoom:
                          totalZoomCnt++;
                          if (todo.status != TodoStatus.done) undoneZoomCnt++;
                          break;
                      }
                    }
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: videoColor,
                            ),
                          ),
                          Text('$undoneVodCnt /$totalVodCnt'),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                          Text('$undoneAssignCnt /$totalAssignCnt'),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                          Text('$undoneZoomCnt /$totalZoomCnt'),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
