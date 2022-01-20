import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/data/activity.dart';
import 'package:pnu_plato_advanced_browser/data/courseArticle.dart';
import 'package:pnu_plato_advanced_browser/data/courseAssistant.dart';
import 'package:pnu_plato_advanced_browser/data/professor.dart';

class ActivityController {
  final List<Activity> _activityList = <Activity>[];

  Future<bool> getCourseActivityList(String courseId) async {
    var options = dio.Options(headers: {'Cookie': Get.find<UserDataController>().moodleSessionKey});
    var response = await request(CommonUrl.courseMainUrl + courseId, options: options, callback: Get.find<UserDataController>().login);
    if (response == null) {
      /* TODO : 에러 */
      return false;
    }
    Document document = parse(response.data);
    final String courseTitle = _getCourseTitle(document);
    final Professor professorInfo = _getProfessorInfo(document);
    final List<CourseAssistant> assistantInfoList = _getAssistantInfoList(document, professorInfo);
    final List<CourseArticle> articleList = _getArticleList(document);

    for (var activity in document.getElementsByClassName('activity')) {
      final String weeks = _getWeeks(activity);
      final String id = _getId(activity);
      final String type = _getType(activity);
      final String description = _getDescription(activity);
      final String title = _getTitle(activity);
      final String? info = _getInfo(activity, type);
      final List<DateTime?> dueDate = _getDueTime(activity);

      //print('$weeks, $id, $type, $description, $title, $info, ${dueDate[0]}, ${dueDate[1]}');
    }

    /* TODO: 강의 개요(summary) 가져오기 */
    for (var item in document.getElementsByClassName('summary')) {
      final String weeks = _getWeeks(item);
      final String summary = item.text;
      print(summary);
    }

    return true;
  }

  List<DateTime?> _getDueTime(Element activity) {
    var res = <DateTime?>[];
    if (activity.getElementsByClassName('text-ubstrap').isEmpty) {
      /* TODO: duetime 가져오기 */
      res.add(DateTime.now());
      res.add(DateTime.now());
    } else {
      bool isLateExist = activity.getElementsByClassName('text-late').isNotEmpty;
      res.add(DateTime.parse(activity.getElementsByClassName('text-ubstrap')[0].text.split(' ~ ')[0].trim()));
      if (isLateExist) {
        res.add(DateTime.parse(activity
            .getElementsByClassName('text-ubstrap')[0]
            .text
            .split(' ~ ')[1]
            .replaceAll(activity.getElementsByClassName('text-late')[0].text, '')
            .trim()));
        res.add(DateTime.parse(activity.getElementsByClassName('text-late')[0].text.split('지각 : ')[1].replaceAll(')', '')));
      } else {
        res.add(DateTime.parse(activity.getElementsByClassName('text-ubstrap')[0].text.split(' ~ ')[1]));
      }
    }
    return res;
  }

  String? _getInfo(Element activity, String type) {
    if (activity.getElementsByClassName('text-info').isEmpty) {
      return null;
    } else {
      if (type == 'vod') {
        return activity.getElementsByClassName('text-info')[0].text.substring(1);
      } else {
        return activity.getElementsByClassName('text-info')[0].text;
      }
    }
  }

  String _getTitle(Element activity) {
    if (activity.getElementsByClassName('instancename').isEmpty) {
      return '';
    } else {
      var temp = activity.getElementsByClassName('instancename')[0].text.split(' ');
      temp.removeLast();
      return temp.join(' ');
      /* 뒤에 붙은 필요 없는 단어 제거 오류 시 사용
      final String unusedName =
          activity.getElementsByClassName('accesshide ').isEmpty ? '' : activity.getElementsByClassName('accesshide ')[0].text;
      var temp = activity.getElementsByClassName('instancename')[0].text.split('unusedName');
      name = temp.join();
      */
    }
  }

  String _getDescription(Element activity) {
    return activity.getElementsByClassName('contentwithoutlink ').fold<String>('', (prv, e) => prv + e.text) +
        activity.getElementsByClassName('contentafterlink').fold<String>('', (prv, e) => prv + e.text);
  }

  String _getType(Element activity) {
    return activity.classes.elementAt(1);
  }

  String _getWeeks(Element activity) {
    return activity.parent!.parent!.getElementsByClassName('sectionname')[0].text;
  }

  String _getId(Element activity) {
    return activity.id.split('-')[1];
  }

  String _getCourseTitle(Document document) {
    return document.getElementsByClassName('coursename')[0].text.split(' ')[0];
  }

  Professor _getProfessorInfo(Document document) {
    return Professor(
      name: document.getElementsByClassName('prof-user-name')[0].text.trim(),
      id: document.getElementsByClassName('prof-user-message')[0].children[0].attributes['href']!.split('?id=')[1],
    );
  }

  List<CourseAssistant> _getAssistantInfoList(Document document, Professor professorInfo) {
    var res = <CourseAssistant>[];
    if (document.getElementsByClassName('prof').isEmpty) {
      return res;
    }
    for (var item in document.getElementsByClassName('prof')) {
      final String type = item.parent!.parent!.parent!.children[0].text.trim();
      res.add(CourseAssistant(
        name: item.text.trim(),
        type: type,
        id: item.attributes['href']!.split('?id=')[1],
      ));
    }
    return res;
  }

  List<CourseArticle> _getArticleList(Document document) {
    var res = <CourseArticle>[];
    if (document.getElementsByClassName('article-list-item').isEmpty) {
      return res;
    }
    for (var item in document.getElementsByClassName('article-list-item')) {
      var temp = item.children[0].attributes['href']!.split('&bwid=');
      res.add(CourseArticle(
        title: item.getElementsByClassName('article-subject')[0].text,
        date: item.getElementsByClassName('article-date')[0].text,
        id: temp[1],
        boardId: temp[0].split('?id=')[1],
      ));
    }
    return res;
  }
}
