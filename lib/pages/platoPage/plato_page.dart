import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/login_builder_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/sections/lecture_tile.dart';

class PlatoPage extends StatelessWidget {
  const PlatoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExpandedTileController _expandedTileController = ExpandedTileController(isExpanded: true);
    return Scaffold(
      appBar: MainAppbar("플라토"),
      drawer: const MainDrawer(),
      body: LoginBuilderPage(
        () => FutureBuilder(
            future: CourseController.updateCurrentSemesterCourseList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return RefreshIndicator(
                  onRefresh: () async => null,
                  child: ListView(
                    children: [
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
                              for (Course course in CourseController.currentSemesterCourseList) ...[
                                LectureTile(course: course),
                                const SizedBox(height: 10),
                              ],
                            ],
                          ))
                    ],
                  ),
                );
              } else {
                return const LoadingPage(msg: '동기화 중...');
              }
            }),
      ),
    );
  }
}
