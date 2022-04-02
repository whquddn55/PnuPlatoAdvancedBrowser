import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/data/course_assistant.dart';
import 'package:pnu_plato_advanced_browser/data/professor.dart';

class CourseSpec {
  final Professor? professor;
  final List<CourseAssistant> assistantList;
  final List<CourseArticleMetaData> articleList;
  final Map<String, List<CourseActivity>> activityMap;
  final Map<String, String> summaryMap;
  String? currentWeek;
  final Uri koreanPlanUri;
  final Uri englishPlanUri;

  CourseSpec({
    required this.professor,
    required this.assistantList,
    required this.articleList,
    required this.activityMap,
    required this.summaryMap,
    required this.koreanPlanUri,
    required this.englishPlanUri,
    this.currentWeek,
  });
}
