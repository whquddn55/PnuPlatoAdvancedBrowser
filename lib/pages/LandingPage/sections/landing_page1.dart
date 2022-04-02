import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/ladning_image.dart';

class LandingPage1 extends StatelessWidget {
  const LandingPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LandingImage("assets/landingImages/landing1_1.png", 0.3),
                SizedBox(width: 5),
                LandingImage("assets/landingImages/landing1_2.png", 0.3),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LandingImage("assets/landingImages/landing1_3.png", 0.3),
                SizedBox(width: 5),
                LandingImage("assets/landingImages/landing1_4.png", 0.3),
              ],
            ),
            const Divider(height: 10, thickness: 3),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("이제 강의 페이지에서 진행상황을 확인하세요."),
            Text("PPAB는 가능한 빠르게 동기화 하여 여러분의 할 일을 알아서 관리해줍니다."),
            Text(""),
            Text(""),
            Text("놀랍게도 동영상도 다운받을 수 있어요."),
            Text("하지만 PPAB가 출석은 해드리지 못 합니다. 단지 이동중에 끊김없이 볼 수 있도록 다운로드 기능만 제공해드려요."),
          ],
        ),
      ],
    );
  }
}
