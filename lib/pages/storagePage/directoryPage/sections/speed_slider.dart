import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class SpeedSlider extends StatefulWidget {
  final BetterPlayerController controller;
  const SpeedSlider({Key? key, required this.controller}) : super(key: key);

  @override
  _SpeedSliderState createState() => _SpeedSliderState();
}

class _SpeedSliderState extends State<SpeedSlider> {
  double speed = 1.0;
  @override
  Widget build(BuildContext context) {
    return Slider(
      onChanged: (value) {
        setState(() => speed = value);
        widget.controller.setSpeed(speed);
      },
      value: speed,
      min: 0.25,
      max: 2.00,
      label: speed.toStringAsFixed(2),
      divisions: 35,
    );
  }
}
