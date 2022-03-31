import 'package:flutter/material.dart';

class LandingPage6 extends StatelessWidget {
  const LandingPage6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const BoxDecoration _imageDecoration = BoxDecoration(boxShadow: [BoxShadow(color: Colors.white)]);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: _imageDecoration,
                    child: Image.asset("assets/landingImages/landing5.png", height: MediaQuery.of(context).size.height * 0.6),
                  ),
                ),
                const Divider(height: 10, thickness: 3),
              ],
            ),
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
