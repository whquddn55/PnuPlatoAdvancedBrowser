import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';

class CourseController {
  List<Course> _currentSemesterCourseList = <Course>[];

  List<Course> get currentSemesterCourseList => _currentSemesterCourseList;

  Future<List<Course>?> getCourseList(int year, int semester) async {
    return await _fetchCourseList(year: year, semester: semester);
  }

  Future<bool> updateCurrentSemesterCourseList() async {
    var res = await _fetchCourseList(year: 2021, semester: 11);
    if (res == null) {
      return false;
    }
    _currentSemesterCourseList = res;
    return true;
  }

  Future<List<Course>?> _fetchCourseList({int year = 0, int semester = 0}) async {
    final List<Course> courseList = <Course>[];

    var options = Dio.Options(headers: {'Cookie': Get.find<UserDataController>().moodleSessionKey});
    var response =
        await request(CommonUrl.courseListUrl + 'year=$year&semester=$semester', options: options, callback: Get.find<UserDataController>().login);
    if (response == null) {
      /* TODO: 에러메시지 */
      return null;
    }

    Document document = parse(response.data);
    for (var e in document.getElementsByClassName('coursefullname')) {
      var middle = e.text.split(' ');
      courseList.add(Course(
        title: middle[0],
        sub: middle[1].split('-')[1].substring(0, middle[1].split('-')[1].length - 1),
        id: e.attributes['href']!.split('id=')[1],
      ));
    }
    return courseList;
  }
}
