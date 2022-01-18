import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/courseListController.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/sections/lectureTile.dart';

class PlatoPage extends StatefulWidget {
  const PlatoPage({Key? key}) : super(key: key);

  @override
  State<PlatoPage> createState() => _PlatoPageState();
}

class _PlatoPageState extends State<PlatoPage> {
  final ExpandedTileController _expandedTileController = ExpandedTileController(isExpanded: true);
  var temp = CourseListController.getCurrentSemesterCourses();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          return FutureBuilder(
              future: temp,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      children: [
                        ExpandedTile(
                            theme: ExpandedTileThemeData(
                                headerPadding: EdgeInsets.zero,
                                headerColor: Get.theme.secondaryHeaderColor,
                                headerRadius: 0.0,
                                contentPadding: EdgeInsets.all(8.0),
                                contentRadius: 0.0,
                                contentBackgroundColor: Colors.transparent
                            ),
                            title: const Text('현재 진행 강좌'),
                            controller: _expandedTileController,
                            content: _renderCourseList(
                                snapshot.data as List<Course>)
                        )
                      ]
                  );
                }
                else {
                  return const LoadingPage(msg: '동기화 중...');
                }
              }
          );
        }
      },
    );
  }

  Widget _renderCourseList(List<Course> courseList) {
    return Column(
      children: [
        for (Course course in courseList) ...[
          LectureTile(title: course.title, tail: course.sub),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
