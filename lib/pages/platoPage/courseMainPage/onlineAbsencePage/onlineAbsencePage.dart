import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/courseController.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';

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
          future: Get.find<CourseController>().getVodStatus(courseId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data! as Map<String, bool>;
              return SingleChildScrollView(
                child: Column(
                  children: data.entries.map((entry) {
                    return Row(
                      children: [
                        Text(entry.key),
                        Text(entry.value ? 'O' : 'X'),
                      ],
                    );
                  }).toList(),
                ),
              );
            } else {
              return const LoadingPage(msg: '로딩중 ...');
            }
          },
        ));
  }
}
