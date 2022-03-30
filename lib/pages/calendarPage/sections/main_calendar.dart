import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/quiz_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';
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

  bool _isSameDay(DateTime? day1, DateTime? day2) {
    if (day1 == null || day2 == null) return false;
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }

  Widget _renderMarker(final int cnt, final Color color) {
    return Expanded(
      flex: 1,
      child: Container(
        child: AutoSizeText(
          '$cnt',
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildMarker(final List<Todo> events) {
    int vodCnt = 0;
    int assignCnt = 0;
    int zoomCnt = 0;
    int doneCnt = 0;
    for (Todo event in events) {
      if (event.status == TodoStatus.done) {
        doneCnt++;
        continue;
      }
      switch (event.runtimeType) {
        case AssignTodo:
        case QuizTodo:
          assignCnt++;
          break;
        case VodTodo:
          vodCnt++;
          break;
        case ZoomTodo:
          zoomCnt++;
          break;
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Expanded(flex: 1, child: SizedBox.shrink()),
            const Expanded(flex: 1, child: SizedBox.shrink()),
            if (doneCnt != 0) _renderMarker(doneCnt, Colors.grey) else const Expanded(flex: 1, child: SizedBox.shrink())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (vodCnt != 0) _renderMarker(vodCnt, AppSettingController.to.vodColor) else const Expanded(flex: 1, child: SizedBox.shrink()),
            if (assignCnt != 0) _renderMarker(assignCnt, AppSettingController.to.assignColor) else const Expanded(flex: 1, child: SizedBox.shrink()),
            if (zoomCnt != 0) _renderMarker(zoomCnt, AppSettingController.to.zoomColor) else const Expanded(flex: 1, child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  void _onDaySelected(final DateTime selectedDay, final DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = selectedDay;
    });

    bool empty = true;
    for (var todo in widget.todoList) {
      if (_isSameDay(todo.dueDate, selectedDay)) {
        empty = false;
      }
    }

    if (empty) return;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return SizedBox(
          height: Get.height * 0.4,
          child: GetBuilder<TodoController>(builder: (controller) {
            final undoneEventList =
                controller.todoList.where((event) => _isSameDay(event.dueDate, selectedDay) && event.status != TodoStatus.done).toList();
            final doneEventList =
                controller.todoList.where((event) => _isSameDay(event.dueDate, selectedDay) && event.status == TodoStatus.done).toList();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: undoneEventList.length + doneEventList.length,
              itemBuilder: (context, index) {
                if (index < undoneEventList.length) {
                  return EventTile(event: undoneEventList[index], index: index);
                } else {
                  return EventTile(event: doneEventList[index - undoneEventList.length], index: index);
                }
              },
            );
          }),
        );
      },
    );
  }

  Widget _renderUndatedEvents() {
    final List<Todo> undateEventList = widget.todoList.where((todo) => (todo.dueDate == null || todo.status == TodoStatus.doing)).toList();
    if (undateEventList.isEmpty) return const SizedBox.shrink();

    final List<Widget> children = [];
    children.add(const Divider(height: 20.0));
    children.add(const Text("진행중이거나 마감기한이 없는 할 일"));
    for (int i = 0; i < undateEventList.length; ++i) {
      children.add(EventTile(event: undateEventList[i], index: i));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Todo>(
          availableGestures: AvailableGestures.horizontalSwipe,
          focusedDay: _focusedDay,
          firstDay: DateTime(2020, 01, 01),
          lastDay: DateTime(2040, 12, 31),
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
          onDaySelected: _onDaySelected,
          eventLoader: (day) {
            var eventList = <Todo>[];
            for (var todo in widget.todoList) {
              if (_isSameDay(todo.dueDate, day)) {
                eventList.add(todo);
              }
            }
            return eventList;
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) => _buildMarker(events),
          ),
        ),
        _renderUndatedEvents(),
      ],
    );
  }
}
