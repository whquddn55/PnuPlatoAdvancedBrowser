import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/data/activity.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatefulWidget {
  final Map<DateTime, List<Activity>> _events =
      HashMap(equals: isSameDay, hashCode: (DateTime key) => key.day * 10000000 + key.month * 10000 + key.year)
        ..addAll({
          DateTime.now(): [
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.assign),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.assign),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.video),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.video),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.zoom),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.quiz),
            // ],
            // DateTime(2022, 1, 17): [
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.assign),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.assign),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.video),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.video),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.zoom),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.quiz),
            // ],
            // DateTime(2022, 1, 19): [
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.assign),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.assign),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.video),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.video),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.zoom),
            //   Activity(id: '1', title: 'test', courseId: '1', endDate: DateTime.now(), type: ActivityTime.quiz),
          ]
        });

  MainCalendar({Key? key}) : super(key: key);

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
    return TableCalendar(
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
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = selectedDay;
        });
      },
      eventLoader: (day) {
        return widget._events[day] ?? <Activity>[];
      },
      calendarBuilders: CalendarBuilders(markerBuilder: (context, day, events) {
        events as List<Activity>;
        int videoCnt = 0;
        int assignCnt = 0;
        int zoomCnt = 0;
        for (Activity event in events) {
          // switch (event.type) {
          //   case ActivityTime.video:
          //     videoCnt++;
          //     break;
          //   case ActivityTime.assign:
          //   case ActivityTime.quiz:
          //     assignCnt++;
          //     break;
          //   case ActivityTime.zoom:
          //     zoomCnt++;
          // }
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
                    color: Colors.blue.withOpacity(0.7),
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
                    color: Colors.red.withOpacity(0.7),
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
                    color: Colors.green.withOpacity(0.7),
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
