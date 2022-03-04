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
  void initState() {
    super.initState();
    speed = widget.controller.videoPlayerController!.value.speed;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(children: [
        Flexible(
          flex: 9,
          child: Slider(
            onChanged: (value) {
              setState(() => speed = value);
              widget.controller.setSpeed(speed);
            },
            value: speed,
            min: 0.3,
            max: 2.00,
            divisions: 17,
          ),
        ),
        Flexible(flex: 1, child: Text(speed.toStringAsFixed(2))),
      ]),
    );
  }
}
