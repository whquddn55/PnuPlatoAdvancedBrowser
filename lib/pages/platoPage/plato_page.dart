import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/login_builder_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/sections/lecture_tile.dart';

class PlatoPage extends StatefulWidget {
  const PlatoPage({Key? key}) : super(key: key);

  @override
  State<PlatoPage> createState() => _PlatoPageState();
}

class _PlatoPageState extends State<PlatoPage> {
  List<Course> courseList = [];
  @override
  void initState() {
    courseList = CourseController.currentSemesterCourseList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar("플라토"),
      drawer: const MainDrawer(),
      body: LoginBuilderPage(
        () => RefreshIndicator(
          onRefresh: () async {
            await CourseController.updateCurrentSemesterCourseList();
            setState(() {
              courseList = CourseController.currentSemesterCourseList;
            });
          },
          child: ListView.separated(
            itemCount: CourseController.currentSemesterCourseList.length,
            itemBuilder: (context, index) => LectureTile(course: CourseController.currentSemesterCourseList[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          ),
        ),
      ),
    );
  }
}
