import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/todo.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/event_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatefulWidget {
  final List<Todo> todoList;
  const MainCalendar(this.todoList, {Key? key}) : super(key: key);

  @override
  _MainCalendarState createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  bool _isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Todo>(
      focusedDay: _focusedDay,
      firstDay: DateTime(2020, 01, 01),
      lastDay: DateTime(2025, 12, 31),
      locale: 'ko-KR',
      sixWeekMonthsEnforced: true,
      headerStyle: const HeaderStyle(
        headerMargin: EdgeInsets.zero,
        headerPadding: EdgeInsets.zero,
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronIcon: Icon(Icons.arrow_left),
        rightChevronIcon: Icon(Icons.arrow_right),
        titleTextStyle: TextStyle(fontSize: 17.0),
      ),
      rowHeight: 52 + 15,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Get.theme.disabledColor,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Get.theme.primaryColor,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: const TextStyle(color: Colors.red),
        tableBorder: TableBorder.all(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5.0),
        ),
        cellMargin: const EdgeInsets.fromLTRB(0, 5, 0, 20),
      ),
      daysOfWeekHeight: 20,
      daysOfWeekStyle:
          DaysOfWeekStyle(weekendStyle: const TextStyle(color: Colors.red), decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3))),
      onHeaderTapped: (_) {
        setState(() {
          _selectedDay = DateTime.now();
          _focusedDay = DateTime.now();
        });
      },
      selectedDayPredicate: (day) {
        return _isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        var eventList = widget.todoList.where((event) => _isSameDay(event.dueDate, selectedDay)).toList();
        if (eventList.isEmpty) return;

        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = selectedDay;
        });

        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          builder: (context) {
            return SizedBox(
              height: Get.height * 0.4,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventList.length,
                itemBuilder: (context, index) {
                  return EventWidget(event: eventList[index], index: index);
                },
              ),
            );
          },
        );
      },
      eventLoader: (day) {
        var eventList = <Todo>[];
        for (var todo in widget.todoList) {
          if (_isSameDay(todo.dueDate, day)) {
            eventList.add(todo);
          }
        }
        return eventList;
      },
      calendarBuilders: CalendarBuilders(markerBuilder: (context, day, events) {
        int videoCnt = 0;
        int assignCnt = 0;
        int zoomCnt = 0;
        for (Todo event in events) {
          switch (event.type) {
            case TodoType.vod:
              videoCnt++;
              break;
            case TodoType.assign:
            case TodoType.quiz:
              assignCnt++;
              break;
            case TodoType.zoom:
              zoomCnt++;
          }
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (videoCnt != 0)
              Expanded(
                flex: 1,
                child: Container(
                  child: Text('$videoCnt', textAlign: TextAlign.center),
                  decoration: BoxDecoration(
                    color: videoColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              )
            else
              const Expanded(flex: 1, child: SizedBox.shrink()),
            if (assignCnt != 0)
              Expanded(
                flex: 1,
                child: Container(
                  child: Text('$assignCnt', textAlign: TextAlign.center),
                  decoration: BoxDecoration(
                    color: assignColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              )
            else
              const Expanded(flex: 1, child: SizedBox.shrink()),
            if (zoomCnt != 0)
              Expanded(
                flex: 1,
                child: Container(
                  child: Text('$zoomCnt', textAlign: TextAlign.center),
                  decoration: BoxDecoration(
                    color: zoomColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              )
            else
              const Expanded(flex: 1, child: SizedBox.shrink()),
          ],
        );
      }),
    );
  }
}
