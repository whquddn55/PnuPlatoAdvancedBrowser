import 'package:flutter/material.dart';

class LandingPage4 extends StatelessWidget {
  const LandingPage4({Key? key}) : super(key: key);

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
                    child: Image.asset("assets/landingImages/landing4_1.png", height: MediaQuery.of(context).size.height * 0.6),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration: _imageDecoration,
                    child: Image.asset("assets/landingImages/landing4_2.png", height: MediaQuery.of(context).size.height * 0.6),
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
            Text("다운받은 파일들을 모아서 볼 수 있어요."),
            Text("PPAB는 혹시나 있을 저작권문제를 위해 모든 파일을 앱 내부에 저장합니다."),
            Text("※PPAB의 다운로드 기능은 파일을 백업/공유하는 목적이 아니라 인터넷환경이 좋지 못한상태에서 끊김없이 보기 위한 목적으로 제공합니다.", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("※동영상 외부공유를 막기위해 반드시 로그인 이후 접근이 가능하며, 따라서 인터넷 연결이 되어 있어야합니다.", style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text("※앱을 삭제하면 다운받은 파일도 모두 삭제되니 주의해주세요.", style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
