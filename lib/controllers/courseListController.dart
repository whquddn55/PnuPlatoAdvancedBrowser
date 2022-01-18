import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';

class CourseListController {
  static Future<List<Course>?> getCurrentSemesterCourses() async {
    var options = Dio.Options(
        headers: {
          'Cookie': Get.find<UserDataController>().moodleSessionKey
        });
    var response = await request(CommonUrl.courseListUrl + 'year=2021&semester=20', options: options, callback: Get.find<UserDataController>().login);
    if (response == null) {
      /* TODO: 에러메시지 */
      return null;
    }
    Document document = parse(response.data);
    var courseList = <Course>[];
    for (var e in document.getElementsByClassName('coursefullname')) {
      var middle = e.text.split(' ');
      courseList.add(Course(
        title: middle[0],
        sub: middle[1].split('-')[1].substring(0, middle[1].split('-')[1].length - 1),
        id: e.attributes['href']!.split('id=')[1],
      ));
    }
    if (courseList.isEmpty) {
      return null;
    }
    return courseList;
  }
}