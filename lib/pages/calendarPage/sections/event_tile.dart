import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';

class EventTile extends StatelessWidget {
  final Todo event;
  final int index;
  const EventTile({Key? key, required this.event, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var course = CourseController.getCourseById(event.courseId);

    final Color eventColor = event.getColor();
    final String dateString = event.dueDate == null ? '' : DateFormat.Hms().format(event.dueDate!);
    final Widget remainTextWidget = _RemainText(dueDate: event.dueDate);

    return Opacity(
      opacity: event.status == TodoStatus.done ? 0.3 : 1.0,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          InkWell(
            onLongPress: () async => await TodoController.to.changeTodoStatus(context, event),
            onTap: () => event.open(context),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0, left: 20.0),
              margin: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0, left: 15.0),
              decoration: BoxDecoration(color: const Color(0xffdddddd), borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Flexible(flex: 8, child: Text(course?.title ?? '알 수 없음')),
                    Wrap(children: [Text(dateString)]),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Flexible(flex: 8, child: NFMarquee(text: event.title, fontWeight: FontWeight.normal)),
                    Wrap(children: [remainTextWidget])
                  ]),
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
  final DateTime? dueDate;
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
    if (widget.dueDate == null) return const SizedBox.shrink();
    Duration remainTime = widget.dueDate!.difference(DateTime.now());
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
