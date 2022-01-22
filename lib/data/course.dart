import 'package:flutter_html/flutter_html.dart';
import 'package:pnu_plato_advanced_browser/data/activity.dart';
import 'package:pnu_plato_advanced_browser/data/courseArticle.dart';
import 'package:pnu_plato_advanced_browser/data/courseAssistant.dart';
import 'package:pnu_plato_advanced_browser/data/professor.dart';

class Course {
  final String title;
  final String sub;
  final String id;
  Professor? professor;
  List<CourseAssistant> assistantList = [];
  List<CourseArticle> articleList = [];
  final Map<String, List<Activity>> activityMap = <String, List<Activity>>{};
  final Map<String, String> summaryMap = <String, String>{};
  late Uri koreanPlanUri;
  late Uri englishPlanUri;

  Course({required this.title, required this.sub, required this.id});
}
