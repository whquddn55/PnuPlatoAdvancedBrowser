import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_article_controller.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/data/course_assistant.dart';
import 'package:pnu_plato_advanced_browser/data/course_spec.dart';
import 'package:pnu_plato_advanced_browser/data/professor.dart';

abstract class CourseSpecController {
  static Future<CourseSpec> fetchCourseSpecification(final String courseId, final String courseTitle) async {
    var response = await requestGet(CommonUrl.courseMainUrl + courseId, isFront: true);
    if (response == null) {
      throw Exception("response is null on fetchCourseSpecification");
    }
    Document document = parse(response.data);

    /* 강의 개요(summary) 가져오기 */
    final Map<String, String> summaryMap = {};
    for (var item in [
      ...document.getElementById('section-0')!.getElementsByClassName('summary'),
      ...document.getElementById('course-all-sections')!.getElementsByClassName('summary'),
    ]) {
      final String weeks = _getWeeks(item);
      summaryMap[weeks] = item.innerHtml;
    }

    /* Activity 가져오기 */
    final Map<String, List<CourseActivity>> activityMap = {};
    for (var activity in [
      ...document.getElementById('section-0')!.getElementsByClassName('activity'),
      ...document.getElementById('course-all-sections')!.getElementsByClassName('activity'),
    ]) {
      final String weeks = _getWeeks(activity);

      final String id = _getId(activity);
      final String type = _getType(activity);
      final String description = _getDescription(activity);
      final String title = _getTitle(activity);
      final String info = _getInfo(activity, type);
      final List<DateTime?> dueDate = _getDueTime(activity);
      final String? iconUrl = _getIconUrl(activity);
      final String availablilityInfo =
          activity.getElementsByClassName('availabilityinfo').isEmpty ? '' : activity.getElementsByClassName('availabilityinfo')[0].innerHtml;
      final bool availablility = activity.getElementsByTagName('a').isNotEmpty;
      final String? url = availablility ? activity.getElementsByTagName('a')[0].attributes['href'] : null;
      var newActivity = CourseActivity.fromType(
        type: type,
        title: title.trim(),
        id: id,
        courseId: courseId,
        courseTitle: courseTitle,
        description: description.trim(),
        info: info.trim(),
        startDate: dueDate[0],
        endDate: dueDate[1],
        lateDate: dueDate[2],
        iconUrl: iconUrl,
        availablilityInfo: availablilityInfo,
        availablility: availablility,
        url: url,
      );

      if (activityMap[weeks] == null) {
        activityMap[weeks] = <CourseActivity>[];
      }

      activityMap[weeks]!.add(newActivity);
    }

    return CourseSpec(
      professor: _getProfessorInfo(document),
      assistantList: _getAssistantInfoList(document),
      articleList: _getArticleList(document),
      koreanPlanUri: _getKoreanPlanUri(document),
      englishPlanUri: _getEnglishPlanUri(document),
      currentWeek: document.getElementsByClassName('course-box-current').isEmpty
          ? null
          : document.getElementsByClassName('course-box-current')[0].getElementsByClassName('sectionname')[0].text,
      activityMap: activityMap,
      summaryMap: summaryMap,
    );
  }

  // static List<CourseActivity> getBoardList(final String courseId) {
  //   var res = <CourseActivity>[];
  //   for (var course in currentSemesterCourseList) {
  //     if (course.id == courseId) {
  //       for (var activity in course.activityMap['강의 개요']!) {
  //         if (activity.runtimeType == BoardCourseActivity) {
  //           res.add(activity);
  //         }
  //       }
  //     }
  //   }
  //   return res;
  // }

  static Future<Map<String, dynamic>> getBoardInfo(final String boardId, final int page) async {
    /*
      title: 게시판 이름
      content: 게시판 설명
      articleList: 게시글 목록
      pageLength: 게시판 페이지 수
      writable: 글쓰기 권한 확인
    */
    var response = await requestGet(CommonUrl.courseBoardUrl + '$boardId&page=$page', isFront: true);

    if (response == null) {
      throw Exception("response is null on getBoardInfo");
    }
    Map<String, dynamic> res = <String, dynamic>{};
    Document document = parse(response.data);

    res['title'] = document.getElementsByClassName('main')[0].text.trim();
    res['content'] = document.getElementsByClassName('box generalbox').isEmpty ? '' : document.getElementsByClassName('box generalbox')[0].innerHtml;
    if (document.getElementsByClassName('tp').isEmpty) {
      res['pageLength'] = 1;
    } else {
      res['pageLength'] = int.parse(document.getElementsByClassName('tp')[0].text.split('/')[1].trim());
    }
    res['articleList'] = CourseArticleController.fetchCourseArticleMetaDataList(document, boardId);

    if (document.getElementsByClassName('pull-right').length == 1) {
      res["writable"] = true;
    } else {
      res["writable"] = false;
    }

    return res;
  }

  static Future<bool> checkAutoAbsence(final String courseId) async {
    var response = await requestGet(CommonUrl.courseAutoAbsenceUrl + courseId, isFront: true);
    if (response == null) return false;

    Document document = Document.html(response.data);
    return document.getElementsByTagName('form').isNotEmpty;
  }

  static List<DateTime?> _getDueTime(Element activity) {
    var res = <DateTime?>[null, null, null];
    if (activity.getElementsByClassName('text-ubstrap').isEmpty) {
      /* TODO: duetime 가져오기 */
    } else {
      bool isLateExist = activity.getElementsByClassName('text-late').isNotEmpty;
      res[0] = DateTime.parse(activity.getElementsByClassName('text-ubstrap')[0].text.split(' ~ ')[0].trim());
      if (isLateExist) {
        res[1] = DateTime.parse(activity
            .getElementsByClassName('text-ubstrap')[0]
            .text
            .split(' ~ ')[1]
            .replaceAll(activity.getElementsByClassName('text-late')[0].text, '')
            .trim());
        res[2] = DateTime.parse(activity.getElementsByClassName('text-late')[0].text.split('지각 : ')[1].replaceAll(')', ''));
      } else {
        res[1] = DateTime.parse(activity.getElementsByClassName('text-ubstrap')[0].text.split(' ~ ')[1]);
      }
    }
    return res;
  }

  static String _getInfo(Element activity, String type) {
    if (activity.getElementsByClassName('text-info').isEmpty) {
      return '';
    } else {
      if (type == 'vod') {
        return activity.getElementsByClassName('text-info')[0].text.substring(1);
      } else {
        return activity.getElementsByClassName('text-info')[0].text;
      }
    }
  }

  static String _getTitle(Element activity) {
    if (activity.getElementsByClassName('instancename').isEmpty) {
      return '';
    } else {
      // var temp = activity.getElementsByClassName('instancename')[0].text.split(' ');
      // if (temp.length > 1) {
      //   temp.removeLast();
      // }
      // return temp.join(' ');
      //  뒤에 붙은 필요 없는 단어 제거 오류 시 사용
      final String unusedName = activity.getElementsByClassName('accesshide ').isEmpty ? '' : activity.getElementsByClassName('accesshide ')[0].text;
      var temp = activity.getElementsByClassName('instancename')[0].text.split(unusedName);
      return temp.join();
    }
  }

  static String _getDescription(Element activity) {
    return activity.getElementsByClassName('contentwithoutlink ').fold<String>('', (prv, e) => prv + e.innerHtml) +
        activity.getElementsByClassName('contentafterlink').fold<String>('', (prv, e) => prv + e.innerHtml);
  }

  static String _getType(Element activity) {
    return activity.classes.elementAt(1);
  }

  static String _getWeeks(Element activity) {
    return activity.parent!.parent!.getElementsByClassName('sectionname')[0].text;
  }

  static String _getId(Element activity) {
    return activity.id.split('-')[1];
  }

  static Professor _getProfessorInfo(Document document) {
    return Professor(
      name: document.getElementsByClassName('prof-user-name')[0].text.trim(),
      id: document.getElementsByClassName('prof-user-message')[0].children[0].attributes['href']!.split('?id=')[1],
      iconUri: Uri.parse(document.getElementsByClassName('prof-user-name')[0].previousElementSibling!.attributes['src']!),
    );
  }

  static List<CourseAssistant> _getAssistantInfoList(final Document document) {
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
        iconUri: Uri.parse(item.children[0].attributes['src']!),
      ));
    }
    return res;
  }

  static List<CourseArticleMetaData> _getArticleList(Document document) {
    var res = <CourseArticleMetaData>[];
    if (document.getElementsByClassName('article-list-item').isEmpty) {
      return res;
    }
    for (var item in document.getElementsByClassName('article-list-item')) {
      var temp = item.children[0].attributes['href']!.split('&bwid=');
      res.add(CourseArticleMetaData(
        title: item.getElementsByClassName('article-subject')[0].text,
        date: item.getElementsByClassName('article-date')[0].text,
        id: temp[1],
        boardId: temp[0].split('?id=')[1],
      ));
    }
    return res;
  }

  static String? _getIconUrl(Element activity) {
    if (activity.getElementsByTagName('img').isEmpty) return null;
    return activity.getElementsByTagName('img')[0].attributes['src'];
  }

  static Uri _getKoreanPlanUri(Document document) {
    return Uri.parse(document.getElementsByClassName('submenu-item')[0].children[0].attributes['href']!);
  }

  static Uri _getEnglishPlanUri(Document document) {
    return Uri.parse(document.getElementsByClassName('submenu-item')[1].children[0].attributes['href']!);
  }
}
