import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/course_zoom.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';

abstract class CourseZoomController {
  static Future<CourseZoom?> fetchCourseZoom(final String activityId) async {
    var response = await requestGet(CommonUrl.courseZoomViewUrl + activityId, isFront: true);

    if (response == null) {
      return null;
    }

    Document document = Document.html(response.data);
    late final DateTime startTime;
    late final String runningTime;
    late final TodoStatus status;
    for (var tr in document.getElementsByClassName('ubzoom_view')[0].getElementsByTagName('tr')) {
      switch (tr.children[0].text) {
        case "시작 시간":
          startTime = DateTime.parse(tr.children[1].text);
          break;
        case "강의 시간":
          runningTime = tr.children[1].text;
          break;
        case "상태":
          final String statusString = tr.children[1].text.trim();
          if (statusString == '진행중') {
            status = TodoStatus.doing;
          } else if (statusString == '종료') {
            status = TodoStatus.done;
          } else {
            status = TodoStatus.undone;
          }
          break;
      }
    }

    return CourseZoom(startTime: startTime, runningTime: runningTime, status: status);
  }

  // static Duration _parseRunningTime(String text) {
  //   int hours = 0;
  //   int minutes = 0;
  //   if (text.contains("시간")) {
  //     hours = int.parse(text.split("시간")[0]);
  //     text = text.split("시간")[1];
  //   }
  //   if (text.contains("분")) {
  //     minutes = int.parse(text.split("분")[0]);
  //   }

  //   return Duration(hours: hours, minutes: minutes);
  // }
}
