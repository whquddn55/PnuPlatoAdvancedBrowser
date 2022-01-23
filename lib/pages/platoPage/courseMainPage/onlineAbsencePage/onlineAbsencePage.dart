import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/courseController.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';

class OnlineAbsencePage extends StatelessWidget {
  final String courseId;
  const OnlineAbsencePage({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CourseController controller = Get.find<CourseController>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Viewer'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: controller.getVodStatus(courseId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data! as Map<String, bool>;
              if (data.keys.isEmpty) {
                return const Center(child: Text('정보를 가져오는데 문제가 발상했습니다.', style: TextStyle(fontSize: 30, color: Colors.red)));
              }
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
