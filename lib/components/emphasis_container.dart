import 'dart:async';

import 'package:flutter/material.dart';

class EmphasisContainer extends StatefulWidget {
  const EmphasisContainer({Key? key}) : super(key: key);

  @override
  State<EmphasisContainer> createState() => _EmphasisContainerState();
}

class _EmphasisContainerState extends State<EmphasisContainer> with SingleTickerProviderStateMixin {
  late final Timer _timer;
  final List<Color> _colorList = [Colors.blue, Colors.purple, Colors.red, Colors.green, Colors.yellow];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) => _changeColor());
  }

  void _changeColor() {
    setState(() {
      _colorIndex += 1;
      _colorIndex %= _colorList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      decoration: BoxDecoration(color: _colorList[_colorIndex].withOpacity(0.1)),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
