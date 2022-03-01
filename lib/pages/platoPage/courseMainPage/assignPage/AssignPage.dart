import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_assign_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_assign.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';

class AssignPage extends StatelessWidget {
  final String assignId;
  const AssignPage({Key? key, required this.assignId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CourseAssign?>(
      future: CourseAssignController.fetchCourseAssign(assignId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingPage(msg: "로딩 중입니다...");
        } else {
          if (snapshot.data == null) {
            return const ErrorPage(msg: "과제 정보를 가져오는데 문제가 발생했습니다...");
          } else {
            final courseAssign = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text(courseAssign.title),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("attatfilelist: ${snapshot.data!.attatchFileList.toString()}"),
                    snapshot.data!.content,
                    Text("dueDate: ${snapshot.data!.dueDate.toString()}"),
                    Text("dueType: ${snapshot.data!.dueType.toString()}"),
                    Text("fileList: ${snapshot.data!.fileList.toString()}"),
                    Text("gradeResult: ${snapshot.data!.gradeResult.toString()}"),
                    Text("graded: ${snapshot.data!.graded.toString()}"),
                    Text("lastEditDate: ${snapshot.data!.lastEditDate.toString()}"),
                    Text("submitted: ${snapshot.data!.submitted.toString()}"),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
