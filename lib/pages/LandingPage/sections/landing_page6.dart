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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: _imageDecoration,
                    child: Image.asset("assets/landingImages/landing6_1.png", height: MediaQuery.of(context).size.height * 0.6),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration: _imageDecoration,
                    child: Image.asset("assets/landingImages/landing6_2.png", height: MediaQuery.of(context).size.height * 0.6),
                  ),
                ),
              ],
            ),
            const Divider(height: 10, thickness: 3),
            const Text("※PPAB는 공식적으로 한국어만 지원합니다.", style: TextStyle(fontSize: 11, color: Colors.redAccent)),
            const Text("※PPAB는 공식적으로 학부 강의만 지원합니다. 제가 대학원을 가면...(안가요)", style: TextStyle(fontSize: 11, color: Colors.redAccent)),
            const Text("※PPAB의 정보는 정확하지 않습니다. 정확한 확인을 원하시면 타 브라우저를 통해서 확인해주세요.", style: TextStyle(fontSize: 11, color: Colors.redAccent)),
            const Text("※PPAB는 버그수정을 위해 학번 정보를 수집합니다. 학번 이외의 비밀번호, 이름등의 정보는 일체 사용되지 않습니다", style: TextStyle(fontSize: 11, color: Colors.redAccent)),
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
