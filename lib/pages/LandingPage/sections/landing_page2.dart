import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/pages/landingPage/sections/ladning_image.dart';

class LandingPage2 extends StatelessWidget {
  const LandingPage2({Key? key}) : super(key: key);

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
                LandingImage("assets/landingImages/landing2_1.png", 0.3),
                SizedBox(width: 5),
                LandingImage("assets/landingImages/landing2_2.png", 0.3),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LandingImage("assets/landingImages/landing2_3.png", 0.3),
                SizedBox(width: 5),
                LandingImage("assets/landingImages/landing2_4.png", 0.3),
              ],
            ),
            const Divider(height: 10, thickness: 3),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("캘린더에서 해야할 일을 할꺼번에 볼 수 있어요."),
            Text("PPAB는 여러분의 할 일을 모아서 캘린더에 보여줍니다."),
            Text("혹시 동기화가 제대로 되지 않는다면 수동으로 수정해보세요."),
            Text(""),
            Text("캘린더 동기화는 아래와 같은 상황에서 자동 동기화 됩니다."),
            Text("1. 12시간마다 모든 강의의 할 일을 동기화", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("2. 각 강의 메인 페이지에 접속 시 해당 강의의 할 일 동기화", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("3. 각 할 일 페이지에 접속 시 해당 할일의 상태 동기화", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("4. 각 할 일의 마감기한이 지날 경우 동기화", style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
