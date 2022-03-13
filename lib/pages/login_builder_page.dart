import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';

class LoginBuilderPage extends StatelessWidget {
  final Widget Function() render;
  const LoginBuilderPage(this.render, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      if (controller.loginInformation.loginStatus == false) {
        return Builder(builder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: const Center(
                child: Text(
              '로그인이 필요합니다.',
              style: TextStyle(
                fontSize: 20.0,
              ),
            )),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          );
        });
      }

      return render();
    });
  }
}
