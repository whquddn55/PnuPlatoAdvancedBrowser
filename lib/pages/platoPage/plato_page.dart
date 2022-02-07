import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/sections/lecture_tile.dart';

class PlatoPage extends StatelessWidget {
  const PlatoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExpandedTileController _expandedTileController = ExpandedTileController(isExpanded: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('플라토'),
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
            return FutureBuilder(
                future: Get.find<CourseController>().updateCurrentSemesterCourseList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                      child: Column(children: [
                        ExpandedTile(
                            theme: ExpandedTileThemeData(
                              headerPadding: const EdgeInsets.all(3.0),
                              headerColor: Get.theme.secondaryHeaderColor,
                              headerRadius: 0.0,
                              contentPadding: const EdgeInsets.all(8.0),
                              contentRadius: 0.0,
                              contentBackgroundColor: Colors.transparent,
                            ),
                            title: const Text('현재 진행 강좌'),
                            controller: _expandedTileController,
                            content: Column(
                              children: [
                                for (Course course in Get.find<CourseController>().currentSemesterCourseList) ...[
                                  LectureTile(course: course),
                                  const SizedBox(height: 10),
                                ],
                              ],
                            ))
                      ]),
                    );
                  } else {
                    return const LoadingPage(msg: '동기화 중...');
                  }
                });
          }
        },
      ),
    );
  }
}
