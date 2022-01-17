import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDataController>(
      builder: (controller) {
        if (controller.loginStatus == false) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: const Center(
                child: Text('로그인이 필요합니다.',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                )
            ),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }
        else {
          return ListView(
            children: [

            ],
          );
        }
      },
    );
  }
}
