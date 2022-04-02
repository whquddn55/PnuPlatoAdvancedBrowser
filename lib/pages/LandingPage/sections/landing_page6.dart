import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/ladning_image.dart';

class LandingPage6 extends StatelessWidget {
  const LandingPage6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LandingImage("assets/landingImages/landing6_1.png", 0.6),
                SizedBox(width: 5),
                LandingImage("assets/landingImages/landing6_2.png", 0.6),
              ],
            ),
            const Divider(height: 10, thickness: 3),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("문제가 발생하면 버그리포트를 통해서 알려주세요."),
          ],
        ),
      ],
    );
  }
}
