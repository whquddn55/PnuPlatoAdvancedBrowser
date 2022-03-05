import 'package:flutter_html/flutter_html.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';
import 'package:pnu_plato_advanced_browser/data/professor.dart';

enum CourseAssignDueType { late, early, over }

class CourseAssign {
  final String title;
  final Html content;
  final List<dynamic> fileList;
  final bool? submitted;
  final bool? graded;
  final bool isUpadtedToOver;
  final bool submitable;
  final DateTime? dueDate;
  final String? dueString;
  final CourseAssignDueType? dueType;
  final DateTime? lastEditDate;
  final List<dynamic> attatchFileList;
  final CourseAssignGradeResult? gradeResult;

  /* TODO: 팀으로 처리하기 */
  final String? team;

  CourseAssign({
    required this.title,
    required this.content,
    required this.fileList,
    required this.submitted,
    required this.graded,
    required this.isUpadtedToOver,
    required this.submitable,
    required this.dueDate,
    required this.dueString,
    required this.dueType,
    required this.lastEditDate,
    required this.attatchFileList,
    required this.gradeResult,
    required this.team,
  });
}

class CourseAssignGradeResult {
  final String grade;
  final DateTime gradeTime;
  final Professor grader;
  final Html? feedback;

  CourseAssignGradeResult({required this.grade, required this.gradeTime, required this.grader, required this.feedback});

  @override
  String toString() {
    return 'grade: $grade, gradeTime: $gradeTime, grader: $grader';
  }
}
