import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';

abstract class CourseController {
  static List<Course> get currentSemesterCourseList => StorageController.loadCourseList();

  static Course? getCourseById(final String courseId) {
    for (var course in currentSemesterCourseList) {
      if (course.id == courseId) return course;
    }
    return null;
  }

  static Course? getCourseByTitle(final String courseTitle) {
    for (var course in currentSemesterCourseList) {
      if (course.title == courseTitle) return course;
    }
    return null;
  }

  // static Future<List<Course>?> fetchCourseList(int year, int semester) async {
  //   return await _fetchCourseList(year: year, semester: semester);
  // }

  static Future<void> updateCurrentSemesterCourseList() async {
    var courseList = await _fetchCurrentCourseList(); // await _fetchCourseList(year: 2022, semester: 10);
    if (courseList == null) return;
    StorageController.storeCourseList(courseList);

    return;
  }

  static Future<Map<int, List<Map<String, dynamic>>>> getVodStatus(final String courseId, final bool isFront) async {
    var response = await requestGet(CommonUrl.courseOnlineAbsenceUrl + courseId, isFront: isFront);

    if (response == null) {
      ExceptionController.onExpcetion("response is null on getVodStatus", true);
      return {};
    }
    if (response.requestOptions.path == "null") {
      return {};
    }

    try {
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
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + "\n" + stacktrace.toString(), true);
    }
    return {};
  }

  static Future<Uri> getM3u8Uri(final String activityId) async {
    var response = await requestGet(CommonUrl.vodViewerUrl + activityId, isFront: true);

    if (response == null) {
      ExceptionController.onExpcetion("response is null on getM3u8Uri", true);
      return Uri.parse('');
    }
    if (response.requestOptions.path == "null") {
      return Uri.parse('');
    }
    try {
      Document document = parse(response.data);
      return Uri.parse(document.getElementsByTagName('source')[0].attributes['src'] ?? '');
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + "\n" + stacktrace.toString(), true);
    }
    return Uri.parse('');
  }

  static Future<List<Course>?> _fetchCourseList({int year = 0, int semester = 0}) async {
    final List<Course> courseList = <Course>[];

    var response = await requestGet(CommonUrl.courseListUrl + 'year=$year&semester=$semester', isFront: true);

    if (response == null) {
      ExceptionController.onExpcetion("response is null on _fetchCourseList", true);
      return null;
    }
    if (response.requestOptions.path == "null") {
      return null;
    }
    try {
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
      return courseList;
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + "\n" + stacktrace.toString(), true);
    }
    return null;
  }

  static Future<List<Course>?> _fetchCurrentCourseList() async {
    final List<Course> courseList = <Course>[];
    var response = await requestAction(PlatoActionType.courseList, isFront: true);
    if (response == null) {
      ExceptionController.onExpcetion("response is null on _fetchCurrentCourseList", true);
      return null;
    }
    if (response.requestOptions.path == "null") {
      return null;
    }

    try {
      Document document = parse(response.data["html"]);
      for (var e in document.getElementsByClassName('course-label-r')) {
        final middle = e.attributes["title"]!.split(' ');
        final sub = middle.last.split('-')[1].substring(0, middle.last.split('-')[1].length - 1);
        middle.removeLast();
        courseList.add(Course(
          title: middle.join(' '),
          sub: sub,
          id: e.attributes['href']!.split('id=')[1],
        ));
      }
      return courseList;
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + "\n" + stacktrace.toString(), true);
    }
    return null;
  }
}
