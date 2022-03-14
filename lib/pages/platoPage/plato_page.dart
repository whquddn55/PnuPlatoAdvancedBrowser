import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
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
    return Scaffold(
      appBar: MainAppbar("플라토"),
      drawer: const MainDrawer(),
      body: LoginBuilderPage(
        () => FutureBuilder(
            future: CourseController.updateCurrentSemesterCourseList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) return const LoadingPage(msg: '동기화 중...');
              return RefreshIndicator(
                onRefresh: () async => null,
                child: ListView.separated(
                  itemCount: CourseController.currentSemesterCourseList.length,
                  itemBuilder: (context, index) => LectureTile(course: CourseController.currentSemesterCourseList[index]),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                ),
              );
            }),
      ),
    );
  }
}
