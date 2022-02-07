import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/pages/bugReportPage/sections/bug_report_chatting.dart';
import 'package:pnu_plato_advanced_browser/pages/bugReportPage/sections/bug_report_input.dart';

class BugReportPage extends StatelessWidget {
  final String studentId;
  final bool isAdmin;
  const BugReportPage(this.studentId, this.isAdmin, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("버그리포트"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: BugReportChatting(studentId, isAdmin)),
          BugReportInput(studentId, isAdmin),
        ],
      ),
    );
  }
}
