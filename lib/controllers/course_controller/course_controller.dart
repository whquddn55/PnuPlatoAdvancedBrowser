import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_article_controller.dart';
import 'package:pnu_plato_advanced_browser/data/activity/board_course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/activity/course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/data/course_assistant.dart';
import 'package:pnu_plato_advanced_browser/data/professor.dart';

abstract class CourseController {
  static final List<Course> _currentSemesterCourseList = <Course>[];

  static List<Course> get currentSemesterCourseList => _currentSemesterCourseList;

  static Course? getCourseById(final String courseId) {
    for (var course in _currentSemesterCourseList) {
      if (course.id == courseId) return course;
    }
    return null;
  }

  static Course? getCourseByTitle(final String courseTitle) {
    for (var course in _currentSemesterCourseList) {
      if (course.title == courseTitle) return course;
    }
    return null;
  }

  static Future<List<Course>?> fetchCourseList(int year, int semester) async {
    return await _fetchCourseList(year: year, semester: semester);
  }

  static Future<bool> updateCurrentSemesterCourseList() async {
    var res = await _fetchCourseList(year: 2022, semester: 10);
    if (res == null) {
      return false;
    }
    _currentSemesterCourseList.removeWhere((course) {
      for (var newCourse in res) {
        if (newCourse.id == course.id) {
          return false;
        }
      }
      return true;
    });
    for (var newCourse in res) {
      bool flag = true;
      for (var course in _currentSemesterCourseList) {
        if (newCourse.id == course.id) {
          flag = false;
          break;
        }
      }
      if (flag) {
        _currentSemesterCourseList.add(newCourse);
      }
    }
    return true;
  }

  static Future<bool> updateCourseSpecification(final Course course) async {
    var response = await requestGet(CommonUrl.courseMainUrl + course.id, isFront: true);
    if (response == null) {
      /* TODO : 에러 */
      return false;
    }
    Document document = parse(response.data);

    course.professor = _getProfessorInfo(document);
    course.assistantList = _getAssistantInfoList(document, course.professor!);
    course.articleList = _getArticleList(document);
    course.koreanPlanUri = _getKoreanPlanUri(document);
    course.englishPlanUri = _getEnglishPlanUri(document);

    course.activityMap.clear();
    course.summaryMap.clear();

    if (document.getElementsByClassName('course-box-current').isNotEmpty) {
      course.currentWeek = document.getElementsByClassName('course-box-current')[0].getElementsByClassName('sectionname')[0].text;
    }

    /* 강의 개요(summary) 가져오기 */
    for (var item in [
      ...document.getElementById('section-0')!.getElementsByClassName('summary'),
      ...document.getElementById('course-all-sections')!.getElementsByClassName('summary'),
    ]) {
      final String weeks = _getWeeks(item);
      course.summaryMap[weeks] = item.innerHtml;

      if (!course.activityMap.keys.contains(weeks)) {
        course.activityMap[weeks] = <CourseActivity>[];
      }
    }

    /* Activity 가져오기 */
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
        courseId: course.id,
        courseTitle: course.title,
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

      course.activityMap[weeks]!.add(newActivity);
    }

    return true;
  }

  static Future<Map<int, List<Map<String, dynamic>>>> getVodStatus(final String courseId, final bool isFront) async {
    var response = await requestGet(CommonUrl.courseOnlineAbsenceUrl + courseId, isFront: isFront);

    if (response == null) {
      /* TODO: 에러 */
      return <int, List<Map<String, String>>>{};
    }

    Map<int, List<Map<String, dynamic>>> res = <int, List<Map<String, dynamic>>>{};
    Document document = parse(response.data);
    if (response.realUri.toString().contains('user_progress_a')) {
      int week = 0;
      for (var tr in document.getElementsByClassName('user_progress_table')[0].children[2].getElementsByTagName('tr')) {
        if (tr.children[0].attributes["rowspan"] != null) {
          week = int.parse(tr.children[0].text);
        }
        if (tr.getElementsByClassName('text-left').isNotEmpty) {
          String title = tr.getElementsByClassName('text-left')[0].text.trim();
          bool status = false;
          for (var e in tr.getElementsByClassName('text-center')) {
            if (e.text.contains('O')) {
              status = true;
            }
          }

          if (res[week] == null) {
            res[week] = [];
          }
          for (var vodStatus in res[week]!) {
            if (vodStatus["title"] == title) {
              title += "_";
            }
          }
          res[week]!.add({"title": title, "status": status});
        }
      }
    } else if (response.realUri.toString().contains('user_progress')) {
      int week = 0;
      for (var tr in document.getElementsByClassName('user_progress')[0].children[2].getElementsByTagName('tr')) {
        if (tr.getElementsByClassName('text-left').isNotEmpty) {
          if (tr.children[0].attributes["rowspan"] != null) {
            week = int.parse(tr.children[0].text);
          }
          String title = tr.getElementsByClassName('text-left')[0].text.trim();
          bool status = false;
          for (var e in tr.getElementsByClassName('text-center')) {
            if (e.text.contains('100%')) {
              status = true;
            }
          }

          if (res[week] == null) {
            res[week] = [];
          }
          for (var vodStatus in res[week]!) {
            if (vodStatus["title"] == title) {
              title += "_";
            }
          }
          res[week]!.add({"title": title, "status": status});
        }
      }
    }

    return res;
  }

  static List<CourseActivity> getBoardList(final String courseId) {
    var res = <CourseActivity>[];
    for (var course in _currentSemesterCourseList) {
      if (course.id == courseId) {
        for (var activity in course.activityMap['강의 개요']!) {
          if (activity.runtimeType == BoardCourseActivity) {
            res.add(activity);
          }
        }
      }
    }
    return res;
  }

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
      /* TODO: 에러 */
      return <String, dynamic>{};
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

  static Future<Uri> getM3u8Uri(final String activityId) async {
    var response = await requestGet(CommonUrl.vodViewerUrl + activityId, isFront: true);

    if (response == null) {
      /* TODO: 에러 */
      return Uri.parse('');
    }
    Document document = parse(response.data);
    return Uri.parse(document.getElementsByTagName('source')[0].attributes['src'] ?? '');
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

  static List<CourseAssistant> _getAssistantInfoList(Document document, Professor professor) {
    var res = <CourseAssistant>[];
    if (document.getElementsByClassName('prof').isEmpty) {
      return res;
    }
    for (var item in document.getElementsByClassName('prof')) {
      if (item.text.trim() == professor.name) {
        continue;
      }
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

  static Future<List<Course>?> _fetchCourseList({int year = 0, int semester = 0}) async {
    final List<Course> courseList = <Course>[];

    var response = await requestGet(CommonUrl.courseListUrl + 'year=$year&semester=$semester', isFront: true);

    if (response == null) {
      /* TODO: 에러 */
      return null;
    }
    Document document = parse(response.data);
    for (var e in document.getElementsByClassName('coursefullname')) {
      final middle = e.text.trim().split(' ');
      final sub = middle.last.split('-')[1].substring(0, middle.last.split('-')[1].length - 1);
      middle.removeLast();
      courseList.add(Course(
        title: middle.join(' '),
        sub: sub,
        id: e.attributes['href']!.split('id=')[1],
      ));
    }

    // var response = await requestAction(PlatoActionType.courseList, isFront: true);
    // if (response == null) {
    //   /* TODO: 에러 */
    //   return null;
    // }

    // Document document = parse(response.data["html"]);
    // for (var e in document.getElementsByClassName('course-label-r')) {
    //   final middle = e.attributes["title"]!.split(' ');
    //   final sub = middle.last.split('-')[1].substring(0, middle.last.split('-')[1].length - 1);
    //   middle.removeLast();
    //   courseList.add(Course(
    //     title: middle.join(' '),
    //     sub: sub,
    //     id: e.attributes['href']!.split('id=')[1],
    //   ));
    // }

    return courseList;
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
