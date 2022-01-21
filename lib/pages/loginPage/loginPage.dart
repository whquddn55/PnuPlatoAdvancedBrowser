import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/pages/loginPage/sections/loginForm.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('로그인'),
          centerTitle: true,
        ),
        body: GestureDetector(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const LoginForm(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(children: [
                    const Text('계정 정보를 잊어버리셨나요?'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: const Text('아이디 찾기'),
                          onPressed: () {
                            Get.toNamed('/login/findInformation/id');
                          },
                        ),
                        TextButton(
                          child: const Text('비밀번호 찾기'),
                          onPressed: () {
                            Get.toNamed('/login/findInformation/pw');
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      '* 아이디/비밀번호는 플라토 인증 외에 어느 곳에서도 사용되지 않으며, 앱 내부 오프라인 스토리지에만 저장되어 서버에 저장되는 정보는 일절 없음을 알려드립니다.',
                      style: TextStyle(color: Get.theme.disabledColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '* 아이디/비밀번호 찾기는 스마트학생지원시스템에서 제공하는 홈페이지로 이동하여 인증하게됩니다.',
                      style: TextStyle(color: Get.theme.disabledColor),
                    ),
                  ]),
                )
              ],
            ),
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
        ));
  }
}
