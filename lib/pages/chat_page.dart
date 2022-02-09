import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar("쪽지"),
      drawer: const MainDrawer(),
      body: GetBuilder<UserDataController>(
        builder: (controller) {
          if (controller.loginStatus == false) {
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
          } else {
            return ListView(
              children: const [],
            );
          }
        },
      ),
    );
  }
}
