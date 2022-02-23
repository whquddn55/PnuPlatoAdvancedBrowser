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
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: GetBuilder<TodoController>(builder: (controller) {
          int videoCnt = 0;
          int assignCnt = 0;
          int zoomCnt = 0;
          for (var todo in controller.todoList) {
            if (todo.courseId == course.id) {
              switch (todo.type) {
                case TodoType.assign:
                case TodoType.quiz:
                  ++assignCnt;
                  break;
                case TodoType.vod:
                  ++videoCnt;
                  break;
                case TodoType.zoom:
                  ++zoomCnt;
                  break;
              }
            }
          }
          return Column(
            children: [
              if (videoCnt != 0)
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
                    Text('$videoCnt'),
                  ],
                ),
              if (assignCnt != 0)
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
                    Text('$assignCnt'),
                  ],
                ),
              if (zoomCnt != 0)
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
                    Text('$zoomCnt'),
                  ],
                ),
            ],
          );
        }),
        title: Text(course.title),
        trailing: Text('[${course.sub}]'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMainPage(course: course)));
        },
      ),
    );
  }
}
