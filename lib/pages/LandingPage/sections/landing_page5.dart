import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/ladning_image.dart';

class LandingPage5 extends StatelessWidget {
  const LandingPage5({Key? key}) : super(key: key);

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
                LandingImage("assets/landingImages/landing5.png", 0.6),
              ],
            ),
            const Divider(height: 10, thickness: 3),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("플라토 알림도 볼 수 있어요."),
            Text("안타깝게도 PPAB는 쪽지알림을 지원하지않아요."),
            Text("다시 한번 말씀 드리지만, 저.. 졸업해야되요."),
          ],
        ),
      ],
    );
  }
}
