import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/onlineAbsencePage/sections/column_vod.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/onlineAbsencePage/sections/column_week.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/onlineAbsencePage/sections/online_absence_header.dart';

class OnlineAbsencePage extends StatelessWidget {
  final String courseId;
  const OnlineAbsencePage({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('온라인 출석부'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: CourseController.getVodStatus(courseId, true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data! as Map<int, List<Map<String, dynamic>>>;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    const OnlineAbsenceHeader(),
                    ...data.entries.map(
                      (entry) {
                        int week = entry.key;
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ColumnWeek(week),
                              ColumnVod(entry),
                            ],
                          ),
                        );
                      },
                    ).toList()
                  ],
                ),
              );
            } else {
              return const LoadingPage(msg: '로딩중 ...');
            }
          },
        ));
  }
}
