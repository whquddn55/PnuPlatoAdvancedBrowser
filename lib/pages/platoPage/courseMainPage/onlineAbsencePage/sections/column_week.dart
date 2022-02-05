import 'package:flutter/material.dart';

class ColumnWeek extends StatelessWidget {
  final DateTime week;
  const ColumnWeek(this.week, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(), right: BorderSide())),
        child: Center(
          child: Text(
              '${week.month <= 9 ? '0' + week.month.toString() : week.month}월${week.day <= 9 ? '0' + week.day.toString() : week.day}일\n${week.hour}:${week.minute}:${week.second}'),
        ),
      ),
    );
  }
}
