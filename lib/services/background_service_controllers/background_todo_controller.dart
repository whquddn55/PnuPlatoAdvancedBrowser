import 'dart:convert';

import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/quiz_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BackgroundTodoController {
  static Future<List<Todo>> fetchTodoList(final List<String> courseIdList) async {
    final List<Todo> todoList = <Todo>[];
    for (var courseId in courseIdList) {
      todoList.addAll(await _fetchVod(courseId));
      todoList.addAll(await _fetchAssign(courseId));
      todoList.addAll(await _fetchQuiz(courseId));
      todoList.addAll(await _fetchZoom(courseId));
    }

    final preference = await SharedPreferences.getInstance();
    await preference.setString("todoList", jsonEncode(todoList));

    return todoList;
  }

  static Future<List<Todo>> _fetchVod(final String courseId) async {
    final List<Map<String, dynamic>> vodStatusList = await _fetchVodStatusList(courseId);
    if (vodStatusList.isEmpty) {
      return [];
    }

    var response = await requestGet(CommonUrl.courseMainUrl + courseId, isFront: false);
    if (response == null) {
      /* TODO : 에러 */
      return [];
    }

    final List<Todo> todoList = <Todo>[];

    html.Document document = parse(response.data);
    for (var activity in document.getElementsByClassName('activity')) {
      if (activity.parent!.parent!.parent!.parent!.parent!.children[0].text == "이번주 강의") {
        continue;
      }

      final String title = _getTitle(activity);
      bool? done;
      for (var vod in vodStatusList) {
        if (vod["title"] == title) {
          done = vod["status"];
        }
      }
      if (done == null) {
        continue;
      }

      final List<DateTime?> dueDate = _getDueTime(activity);
      if (dueDate[1] == null || DateTime.now().compareTo(dueDate[0]!) < 0) {
        continue;
      }

      final String id = _getId(activity);
      final Uri iconUri = _getIconUri(activity);
      final bool availablility = activity.getElementsByTagName('a').isNotEmpty;

      todoList.add(VodTodo(
        availability: availablility,
        courseId: courseId,
        dueDate: dueDate[1]!,
        iconUri: iconUri,
        id: id,
        title: title,
        status: done ? TodoStatus.done : TodoStatus.undone,
      ));
    }
    return todoList;
  }

  static Future<List<Todo>> _fetchAssign(final String courseId) async {
    var response = await requestGet(CommonUrl.courseAssignUrl + courseId, isFront: false);

    if (response == null) {
      /* TODO : 에러 */
      return [];
    }

    final List<Todo> todoList = <Todo>[];

    html.Document document = parse(response.data);
    for (var tr in document.getElementsByTagName('tr')) {
      if (tr.getElementsByClassName('cell c1').isNotEmpty) {
        String title = tr.getElementsByClassName('cell c1')[0].text.trim();
        String id = tr.getElementsByClassName('cell c1')[0].getElementsByTagName('a')[0].attributes['href']!.split('?id=')[1];
        DateTime dueDate = DateTime.tryParse(tr.getElementsByClassName('cell c2')[0].text.trim()) ?? DateTime.now();
        bool done = tr.getElementsByClassName('cell c3')[0].text.trim().contains('완료');

        todoList.add(AssignTodo(
          availability: true,
          courseId: courseId,
          dueDate: dueDate,
          iconUri: Uri.parse("https://plato.pusan.ac.kr/theme/image.php/coursemosv2/assign/1641196863/icon"),
          id: id,
          title: title,
          status: done ? TodoStatus.done : TodoStatus.undone,
        ));
      }
    }
    return todoList;
  }

  static Future<List<Todo>> _fetchQuiz(final String courseId) async {
    var response = await requestGet(CommonUrl.courseQuizUrl + courseId, isFront: false);

    if (response == null) {
      /* TODO : 에러 */
      return [];
    }

    final List<Todo> todoList = <Todo>[];

    html.Document document = parse(response.data);
    for (var tr in document.getElementsByTagName('tr')) {
      if (tr.getElementsByClassName('cell c1').isNotEmpty) {
        String title = tr.getElementsByClassName('cell c1')[0].text.trim();
        String id = tr.getElementsByClassName('cell c1')[0].getElementsByTagName('a')[0].attributes['href']!.split('?id=')[1];
        DateTime dueDate = DateTime.tryParse(tr.getElementsByClassName('cell c2')[0].text.trim()) ?? DateTime.now();
        bool done = tr.getElementsByClassName('cell c3')[0].text.trim().contains('완료') ||
            (tr.getElementsByClassName('cell c3')[0].text.trim() != "-") ||
            (dueDate.compareTo(DateTime.now()) <= 0);

        todoList.add(QuizTodo(
          availability: true,
          courseId: courseId,
          dueDate: dueDate,
          iconUri: Uri.parse("https://plato.pusan.ac.kr/theme/image.php/coursemosv2/assign/1641196863/icon"),
          id: id,
          title: title,
          status: done ? TodoStatus.done : TodoStatus.undone,
        ));
      }
    }
    return todoList;
  }

  static Future<List<Todo>> _fetchZoom(final String courseId) async {
    var response = await requestGet(CommonUrl.courseZoomUrl + courseId, isFront: false);

    if (response == null) {
      /* TODO : 에러 */
      return [];
    }
    final List<Todo> todoList = <Todo>[];
    html.Document document = parse(response.data);
    for (var tr in document.getElementsByTagName('tr')) {
      if (tr.getElementsByClassName('cell c1').isNotEmpty) {
        String title = tr.getElementsByClassName('cell c1')[0].text.trim();
        String id = tr.getElementsByClassName('cell c1')[0].getElementsByTagName('a')[0].attributes['href']!.split('?id=')[1];
        DateTime dueDate = DateTime.parse(tr.getElementsByClassName('cell c2')[0].text.trim());
        bool done = tr.parent!.parent!.classes.contains('mod_index') == false;

        todoList.add(ZoomTodo(
          availability: true,
          courseId: courseId,
          dueDate: dueDate,
          iconUri: Uri.parse("https://plato.pusan.ac.kr/theme/image.php/coursemosv2/zoom/1641196863/icon"),
          id: id,
          title: title,
          status: done ? TodoStatus.done : TodoStatus.undone,
        ));
      }
    }

    return todoList;
  }

  static Future<List<Map<String, dynamic>>> _fetchVodStatusList(final String courseId) async {
    var vodStatusList = <Map<String, dynamic>>[];
    for (var values in (await CourseController.getVodStatus(courseId, false)).values) {
      for (var vodStatus in values) {
        vodStatusList.add(vodStatus);
      }
    }
    return vodStatusList;
  }

  static String _getTitle(html.Element activity) {
    if (activity.getElementsByClassName('instancename').isEmpty) {
      return '';
    } else {
      final String unusedName = activity.getElementsByClassName('accesshide ').isEmpty ? '' : activity.getElementsByClassName('accesshide ')[0].text;
      var temp = activity.getElementsByClassName('instancename')[0].text.split(unusedName);
      return temp.join();
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

  static String _getId(html.Element activity) {
    return activity.id.split('-')[1];
  }

  static Uri _getIconUri(html.Element activity) {
    return Uri.parse(activity.getElementsByTagName('img')[0].attributes['src']!);
  }
}
