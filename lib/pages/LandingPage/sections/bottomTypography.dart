import 'package:flutter/material.dart';

class BottomTypography extends StatelessWidget {
  const BottomTypography({Key? key}) : super(key: key);

  TextStyle _outlinedTextStyle(Color color) {
    return TextStyle(inherit: true, fontSize: 40.0, color: color, shadows: const [
      Shadow(
          // bottomLeft
          offset: Offset(-1.5, -1.5),
          color: Colors.white),
      Shadow(
          // bottomRight
          offset: Offset(1.5, -1.5),
          color: Colors.white),
      Shadow(
          // topRight
          offset: Offset(1.5, 1.5),
          color: Colors.white),
      Shadow(
          // topLeft
          offset: Offset(-1.5, 1.5),
          color: Colors.white),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(text: 'P', children: [TextSpan(text: 'nu', style: _outlinedTextStyle(Colors.grey))]),
              style: _outlinedTextStyle(Colors.lightBlue)),
          Text.rich(TextSpan(text: 'P', children: [TextSpan(text: 'lato', style: _outlinedTextStyle(Colors.grey))]),
              style: _outlinedTextStyle(Colors.lightBlue)),
          Text.rich(TextSpan(text: 'A', children: [TextSpan(text: 'davanced', style: _outlinedTextStyle(Colors.grey))]),
              style: _outlinedTextStyle(Colors.lightBlue)),
          Text.rich(TextSpan(text: 'B', children: [TextSpan(text: 'rowser', style: _outlinedTextStyle(Colors.grey))]),
              style: _outlinedTextStyle(Colors.lightBlue)),
        ],
      ),
    );
  }
}
