import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/sections/navigator_body.dart';

class NavigatorPage extends StatelessWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _loginFuture = Get.find<UserDataController>().login();

    return FutureBuilder(
      future: _loginFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const NavigatorBody();
        }
        return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: '로그인 중...'));
      },
    );
  }
}
