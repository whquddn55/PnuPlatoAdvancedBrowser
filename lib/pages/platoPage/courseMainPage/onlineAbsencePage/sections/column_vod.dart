import 'package:flutter/material.dart';

class ColumnVod extends StatelessWidget {
  final MapEntry<int, List<Map<String, dynamic>>> entry;
  const ColumnVod(this.entry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: entry.value
            .map(
              (course) => Container(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: Text(course["title"]),
                      ),
                    ),
                    Icon(
                      course["status"] == true ? Icons.check : Icons.close,
                      color: course["status"] == true ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
