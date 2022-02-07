import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/academic_calendar.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/main_calendar.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('캘린더'),
        centerTitle: true,
        leading: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //Get.find<UserDataController>().studentId.toString()
          stream: FirebaseFirestore.instance.collection("chats").doc("1234").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer());
            }

            int unread = snapshot.data!["unread"];
            return IconButton(
              icon: Badge(
                child: const Icon(Icons.menu),
                badgeContent: Text(unread.toString()),
                showBadge: unread != 0,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  const AcademicCalendar(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MainCalendar(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
