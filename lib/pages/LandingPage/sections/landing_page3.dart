import 'package:flutter/material.dart';

class LandingPage3 extends StatelessWidget {
  const LandingPage3({Key? key}) : super(key: key);

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
                    child: Image.asset("assets/landingImages/landing3.png", height: MediaQuery.of(context).size.height * 0.6),
                  ),
                ),
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
