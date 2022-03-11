import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/course_main_page.dart';

class EventTile extends StatelessWidget {
  final Todo event;
  final int index;
  const EventTile({Key? key, required this.event, required this.index}) : super(key: key);

  void _eventTabEvent(final BuildContext context) {
    var course = Get.find<CourseController>().getCourseById(event.courseId);
    if (course == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ErrorPage(msg: "없는... 강의인데요??")));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseMainPage(
          course: course,
          targetActivityId: event.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var course = Get.find<CourseController>().getCourseById(event.courseId);
    if (course == null) return const SizedBox.shrink();

    late final Color eventColor;
    switch (event.type) {
      case TodoType.vod:
        eventColor = videoColor;
        break;
      case TodoType.assign:
      case TodoType.quiz:
        eventColor = assignColor;
        break;
      case TodoType.zoom:
        eventColor = zoomColor;
        break;
    }

    return Opacity(
      opacity: event.status == TodoStatus.done ? 0.3 : 1.0,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          InkWell(
            onTap: () => _eventTabEvent(context),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0, left: 20.0),
              margin: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0, left: 15.0),
              decoration: BoxDecoration(color: const Color(0xffdddddd), borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(course.title), Text(DateFormat.Hms().format(event.dueDate))]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(event.title), _RemainText(dueDate: event.dueDate)]),
                ],
              ),
            ),
          ),
          Container(height: 30, width: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white)),
          Container(
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: eventColor,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              alignment: Alignment.center,
              child: Text((index + 1).toString(), style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}

class _RemainText extends StatefulWidget {
  final DateTime dueDate;
  const _RemainText({Key? key, required this.dueDate}) : super(key: key);

  @override
  State<_RemainText> createState() => __RemainTextState();
}

class __RemainTextState extends State<_RemainText> {
  late final Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    Duration remainTime = widget.dueDate.difference(DateTime.now());
    if (remainTime.isNegative) return const SizedBox.shrink();

    String days = remainTime.inDays.toString().padLeft(2, '0');
    String hours = (remainTime.inHours % 24).toString().padLeft(2, '0');
    String minutes = (remainTime.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (remainTime.inSeconds % 60).toString().padLeft(2, '0');
    return Text("$days일 $hours:$minutes:$seconds");
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
