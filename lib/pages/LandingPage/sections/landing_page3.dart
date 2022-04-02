import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/ladning_image.dart';

class LandingPage3 extends StatelessWidget {
  const LandingPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LandingImage("assets/landingImages/landing3.png", 0.6),
              ],
            ),
            const Divider(height: 10, thickness: 3),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("안타깝게도 쪽지기능은 구현하지 못 했어요."),
            Text("저.. 졸업해야되요."),
          ],
        ),
      ],
    );
  }
}
