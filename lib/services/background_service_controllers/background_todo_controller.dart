import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo.dart';
import 'package:dio/dio.dart' as dio;
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';

abstract class _TodoController {
  static final List<Todo> todoList = <Todo>[];

  static Future<void> fetchTodoListAll() async {
    for (var course in Get.find<CourseController>().currentSemesterCourseList) {
      await _fetchVod(course.id);
      await _fetchAssign(course.id);
      await _fetchQuiz(course.id);
      await _fetchZoom(course.id);
    }
  }

  static Future<void> fetchTodoListByCourseId(final String courseId) async {
    print("[DEBUG] $courseId");
    await _fetchVod(courseId);
    print("[DEBUG] $courseId");
    await _fetchAssign(courseId);
    print("[DEBUG] $courseId");
    await _fetchQuiz(courseId);
    print("[DEBUG] $courseId");
    await _fetchZoom(courseId);
    print("[DEBUG] $courseId");
  }

  static Future<void> _fetchVod(final String courseId) async {
    var vodStatusList = (await Get.find<CourseController>().getVodStatus(courseId)).values;
    if (vodStatusList.isEmpty) {
      return;
    }
    List<Map<String, dynamic>> vodList = vodStatusList.reduce((value, element) => value + element);

    var options = dio.Options(headers: {'Cookie': Get.find<LoginController>().moodleSessionKey});
    var response = await request(CommonUrl.courseMainUrl + courseId, options: options, callback: Get.find<LoginController>().login);
    if (response == null) {
      /* TODO : 에러 */
      return;
    }
    html.Document document = parse(response.data);

    for (var activity in document.getElementsByClassName('activity')) {
      final TodoType? type = _getType(activity);
      if (type == null) {
        continue;
      }

      final String title = _getTitle(activity);
      bool? done;
      for (var vod in vodList) {
        if (vod.containsKey(title)) {
          done = vod["status"];
        }
      }
      if (done == null) {
        continue;
      }

      final List<DateTime?> dueDate = _getDueTime(activity);
      if (dueDate[1] == null) {
        continue;
      }

      final String id = _getId(activity);
      final Uri iconUri = _getIconUri(activity);
      final bool availablility = activity.getElementsByTagName('a').isNotEmpty;

      todoList.add(Todo(
        availability: availablility,
        courseId: courseId,
        dueDate: dueDate[1]!,
        iconUri: iconUri,
        id: id,
        title: title,
        type: TodoType.vod,
        status: done ? TodoStatus.done : TodoStatus.undone,
      ));
    }
  }

  static Future<void> _fetchAssign(String courseId) async {
    var options = dio.Options(headers: {'Cookie': Get.find<LoginController>().moodleSessionKey});
    var response = await request(CommonUrl.courseAssignUrl + courseId, options: options, callback: Get.find<LoginController>().login);

    if (response == null) {
      /* TODO : 에러 */
      return;
    }
    html.Document document = parse(response.data);
    for (var tr in document.getElementsByTagName('tr')) {
      if (tr.getElementsByClassName('cell c1').isNotEmpty) {
        String title = tr.getElementsByClassName('cell c1')[0].text.trim();
        String id = tr.getElementsByClassName('cell c1')[0].getElementsByTagName('a')[0].attributes['href']!.split('?id=')[1];
        DateTime dueDate = DateTime.tryParse(tr.getElementsByClassName('cell c2')[0].text.trim()) ?? DateTime.now();
        bool done =
            tr.getElementsByClassName('cell c3')[0].text.trim().contains('완료') || (tr.getElementsByClassName('cell c3')[0].text.trim() != "-");

        todoList.add(Todo(
          availability: true,
          courseId: courseId,
          dueDate: dueDate,
          iconUri: Uri.parse("https://plato.pusan.ac.kr/theme/image.php/coursemosv2/assign/1641196863/icon"),
          id: id,
          title: title,
          type: TodoType.assign,
          status: done ? TodoStatus.done : TodoStatus.undone,
        ));
      }
    }
  }

  static Future<void> _fetchQuiz(String courseId) async {
    var options = dio.Options(headers: {'Cookie': Get.find<LoginController>().moodleSessionKey});
    var response = await request(CommonUrl.courseQuizUrl + courseId, options: options, callback: Get.find<LoginController>().login);

    if (response == null) {
      /* TODO : 에러 */
      return;
    }
    html.Document document = parse(response.data);
    for (var tr in document.getElementsByTagName('tr')) {
      if (tr.getElementsByClassName('cell c1').isNotEmpty) {
        String title = tr.getElementsByClassName('cell c1')[0].text.trim();
        String id = tr.getElementsByClassName('cell c1')[0].getElementsByTagName('a')[0].attributes['href']!.split('?id=')[1];
        DateTime dueDate = DateTime.tryParse(tr.getElementsByClassName('cell c2')[0].text.trim()) ?? DateTime.now();
        bool done = tr.getElementsByClassName('cell c3')[0].text.trim().contains('완료') ||
            (tr.getElementsByClassName('cell c3')[0].text.trim() != "-") ||
            (dueDate.compareTo(DateTime.now()) <= 0);

        todoList.add(Todo(
          availability: true,
          courseId: courseId,
          dueDate: dueDate,
          iconUri: Uri.parse("https://plato.pusan.ac.kr/theme/image.php/coursemosv2/assign/1641196863/icon"),
          id: id,
          title: title,
          type: TodoType.quiz,
          status: done ? TodoStatus.done : TodoStatus.undone,
        ));
      }
    }
  }

  static Future<void> _fetchZoom(String courseId) async {
    /* TODO: 줌 강의 열리면 새로 짜야함 */

    // var options = Options(headers: {'Cookie': Get.find<UserDataController>().moodleSessionKey});
    // var response = await request(CommonUrl.courseQuizUrl + courseId, options: options, callback: Get.find<UserDataController>().login);

    // if (response == null) {
    //   /* TODO : 에러 */
    //   return;
    // }
    // Document document = parse(response.data);
    // for (var tr in document.getElementsByTagName('tr')) {
    //   if (tr.getElementsByClassName('cell c1').isNotEmpty) {
    //     String title = tr.getElementsByClassName('cell c1')[0].text.trim();
    //     String id = tr.getElementsByClassName('cell c1')[0].getElementsByTagName('a')[0].attributes['href']!.split('?id=')[1];
    //     DateTime dueDate = DateTime.parse(tr.getElementsByClassName('cell c2')[0].text.trim());
    //     bool done = tr.getElementsByClassName('cell c3')[0].text.trim().contains('완료') ||
    //         (tr.getElementsByClassName('cell c3')[0].text.trim() != "-") ||
    //         (dueDate.compareTo(DateTime.now()) <= 0);

    //     _todoList.add(Todo(
    //       availability: true,
    //       courseId: courseId,
    //       dueDate: dueDate,
    //       iconUri: Uri.parse("https://plato.pusan.ac.kr/theme/image.php/coursemosv2/assign/1641196863/icon"),
    //       id: id,
    //       title: title,
    //       type: TodoType.quiz,
    //       status: done ? TodoStatus.done : TodoStatus.undone,
    //     ));
    //   }
    // }
  }

  static String _getTitle(html.Element activity) {
    if (activity.getElementsByClassName('instancename').isEmpty) {
      return '';
    } else {
      var temp = activity.getElementsByClassName('instancename')[0].text.split(' ');
      if (temp.length > 1) {
        temp.removeLast();
      }
      return temp.join(' ');
      /* 뒤에 붙은 필요 없는 단어 제거 오류 시 사용
      final String unusedName =
          activity.getElementsByClassName('accesshide ').isEmpty ? '' : activity.getElementsByClassName('accesshide ')[0].text;
      var temp = activity.getElementsByClassName('instancename')[0].text.split('unusedName');
      name = temp.join();
      */
    }
  }

  static List<DateTime?> _getDueTime(html.Element activity) {
    var res = <DateTime?>[null, null, null];
    if (activity.getElementsByClassName('text-ubstrap').isNotEmpty) {
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

  static TodoType? _getType(html.Element activity) {
    TodoType? type;
    for (var typeValue in TodoType.values) {
      if (typeValue.toString() == activity.classes.elementAt(1)) {
        type = typeValue;
      }
    }
    return type;
  }

  static String _getId(html.Element activity) {
    return activity.id.split('-')[1];
  }

  static Uri _getIconUri(html.Element activity) {
    return Uri.parse(activity.getElementsByTagName('img')[0].attributes['src']!);
  }
}
