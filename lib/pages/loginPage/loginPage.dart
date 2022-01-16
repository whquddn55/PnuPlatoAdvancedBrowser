import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userDataController = Get.find<UserDataController>();

  bool _passwordVisible = false;
  String _loginMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('로그인'),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _renderForm(),
            Text(_loginMsg, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Icon(Icons.navigate_next),
              onPressed: () async {
                var pd = ProgressDialog(context: context);
                pd.show(max: 1, msg: '로그인 중입니다...', progressBgColor: Colors.transparent);
                _formKey.currentState!.save();
                bool loginResult = await _userDataController.login();
                pd.close();
                if (loginResult == false) {
                  setState(() {
                    _loginMsg = _userDataController.loginMsg;
                  });
                }
                else {
                  Get.back();
                }
              },
            ),
            const SizedBox(height: 30),
            _renderNote()
          ],
        )
    );
  }

  Widget _renderForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 20),
                    labelText: 'Plato 아이디'
                ),
                onSaved: (value) =>
                _userDataController.username = value ?? ''
            ),
            const SizedBox(height: 10),
            TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 20),
                    labelText: 'Plato 비밀번호',
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )
                ),
                obscureText: !_passwordVisible,
                onSaved: (value) =>
                _userDataController.password = value ?? ''
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderNote() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children:[
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
          const Text(
            '* 아이디/비밀번호는 플라토 인증 외에 어느 곳에서도 사용되지 않으며, 앱 내부 오프라인 스토리지에만 저장되어 서버에 저장되는 정보는 일절 없음을 알려드립니다.',
            style: TextStyle(
                color: Colors.grey
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '* 아이디/비밀번호 찾기는 스마트학생지원시스템에서 제공하는 홈페이지로 이동하여 인증하게됩니다.',
            style: TextStyle(
                color: Colors.grey
            ),
          ),
        ]
      ),
    );
  }
}
