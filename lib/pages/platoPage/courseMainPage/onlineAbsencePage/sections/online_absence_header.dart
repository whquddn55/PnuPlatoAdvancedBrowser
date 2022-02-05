import 'package:flutter/material.dart';

class OnlineAbsenceHeader extends StatelessWidget {
  const OnlineAbsenceHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(), right: BorderSide())),
              padding: const EdgeInsets.all(8.0),
              child: const Center(child: Text("마감 기한")),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
