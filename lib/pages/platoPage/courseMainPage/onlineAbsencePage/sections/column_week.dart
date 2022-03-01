import 'package:flutter/material.dart';

class ColumnWeek extends StatelessWidget {
  final int week;
  const ColumnWeek(this.week, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(), right: BorderSide())),
        child: Center(
          child: Text('$week 주차'),
        ),
      ),
    );
  }
}
