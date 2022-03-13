import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _idFocusNode = FocusNode();
  final _pwFocusNode = FocusNode();
  String _username = '';
  String _password = '';
  bool _passwordVisible = false;
  String _loginMsg = '';

  void _submit() async {
    FocusScope.of(context).unfocus();
    var dialogContext = await showProgressDialog(context, "로그인 중입니다...");
    _formKey.currentState!.save();

    await LoginController.to.login(autologin: false, username: _username, password: _password);
    closeProgressDialog(dialogContext);

    if (LoginController.to.loginInformation.loginStatus == false) {
      setState(() {
        _loginMsg = LoginController.to.loginInformation.loginMsg;
      });
      _idFocusNode.requestFocus();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  focusNode: _idFocusNode,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      labelText: 'Plato 아이디'),
                  onSaved: (value) => _username = value ?? '',
                  onFieldSubmitted: (_) => _pwFocusNode.requestFocus(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  focusNode: _pwFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      labelText: 'Plato 비밀번호',
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility, color: Get.theme.disabledColor),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      )),
                  obscureText: !_passwordVisible,
                  onSaved: (value) => _password = value ?? '',
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        Text(_loginMsg, style: TextStyle(color: Get.theme.errorColor)),
        const SizedBox(height: 30),
        ElevatedButton(
          child: const Icon(Icons.navigate_next),
          onPressed: _submit,
        ),
      ],
    );
  }
}
