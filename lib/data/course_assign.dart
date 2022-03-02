import 'package:flutter_html/flutter_html.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';
import 'package:pnu_plato_advanced_browser/data/professor.dart';

enum CourseAssignDueType { late, early, over }

class CourseAssign {
  final String title;
  final Html content;
  final List<CourseFile>? fileList;
  final bool? submitted;
  final bool? graded;
  final DateTime? dueDate;
  final String? dueString;
  final CourseAssignDueType? dueType;
  final DateTime? lastEditDate;
  final List<CourseFile>? attatchFileList;
  final CourseAssignGradeResult? gradeResult;

  CourseAssign({
    required this.title,
    required this.content,
    required this.fileList,
    required this.submitted,
    required this.graded,
    required this.dueDate,
    required this.dueString,
    required this.dueType,
    required this.lastEditDate,
    required this.attatchFileList,
    required this.gradeResult,
  });
}

class CourseAssignGradeResult {
  final String grade;
  final DateTime gradeTime;
  final Professor grader;

  CourseAssignGradeResult({required this.grade, required this.gradeTime, required this.grader});

  @override
  String toString() {
    return 'grade: $grade, gradeTime: $gradeTime, grader: $grader';
  }
}
