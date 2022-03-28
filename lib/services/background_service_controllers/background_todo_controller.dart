import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_zoom_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo/assign_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/quiz_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/todo.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/data/todo/vod_todo.dart';
import 'package:pnu_plato_advanced_browser/data/todo/zoom_todo.dart';

abstract class BackgroundTodoController {
  static Set<String> refreshLock = {};
  static Future<void> fetchTodoListAll() async {
    final courseIdList = CourseController.currentSemesterCourseList.map((course) => course.id).toList();
    await fetchTodoList(courseIdList);
    StorageController.storeLastTodoSyncTime(DateTime.now());

    return;
  }

  static Future<void> fetchTodoList(List<String> courseIdList) async {
    /* 중복 업데이트 방지 Lock */
    courseIdList = _lockCourseId(courseIdList);
    if (courseIdList.isEmpty) return;

    final List<Todo> newTodoList = <Todo>[];
    int index = 0;
    for (var courseId in courseIdList) {
      newTodoList.addAll(await _fetchVod(courseId, index));
      newTodoList.addAll(await _fetchAssign(courseId, index));
      newTodoList.addAll(await _fetchQuiz(courseId, index));
      newTodoList.addAll(await _fetchZoom(courseId, index));
    }

    var todoList = StorageController.loadTodoList();

    _updateTodoList(todoList, newTodoList);
    StorageController.storeTodoList(todoList);

    /* unlock */
    _unlockCourseId(courseIdList);

    return;
  }

  static List<String> _lockCourseId(final List<String> courseIdList) {
    return courseIdList.where((courseId) {
      return refreshLock.add(courseId);
    }).toList();
  }

  static void _unlockCourseId(final List<String> courseIdList) {
    for (var courseId in courseIdList) {
      refreshLock.remove(courseId);
    }
  }

  static void _updateTodoList(List<Todo> prvTodoList, List<Todo> newTodoList) {
    for (var newTodo in newTodoList) {
      int prvIndex = prvTodoList.indexOf(newTodo);
      if (prvIndex != -1) {
        newTodo.checked = prvTodoList[prvIndex].checked;
        prvTodoList[prvIndex] = newTodo;
      } else {
        prvTodoList.add(newTodo);
      }
    }
  }

  static Future<List<Todo>> _fetchVod(final String courseId, int index) async {
    final List<Map<String, dynamic>> vodStatusList = await _fetchVodStatusList(courseId);
    if (vodStatusList.isEmpty) {
      return [];
    }

    var response = await requestGet(CommonUrl.courseMainUrl + courseId, isFront: false);
    if (response == null) {
      throw Exception("response is null on _fetchVod");
    }

    final List<Todo> todoList = <Todo>[];

    html.Document document = parse(response.data);
    for (var activity in document.getElementsByClassName('activity')) {
      if (activity.parent!.parent!.parent!.parent!.parent!.children[0].text == "이번주 강의") {
        continue;
      }

      String title = _getTitle(activity);
      for (var todo in todoList) {
        if (todo.title == title) {
          title += '_';
        }
      }
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
      final String iconUrl = _getIconUri(activity);
      final bool availablility = activity.getElementsByTagName('a').isNotEmpty;

      todoList.add(VodTodo(
        index: index,
        availability: availablility,
        courseId: courseId,
        dueDate: dueDate[1]!,
        iconUrl: iconUrl,
        id: id,
        title: title,
        status: done ? TodoStatus.done : TodoStatus.undone,
        userDefined: false,
        checked: false,
      ));
    }
    return todoList;
  }

  static Future<List<Todo>> _fetchAssign(final String courseId, int index) async {
    var response = await requestGet(CommonUrl.courseAssignUrl + courseId, isFront: false);

    if (response == null) {
      throw Exception("response is null on _fetchAssign");
    }

    final List<Todo> todoList = <Todo>[];

    html.Document document = parse(response.data);
    for (var tr in document.getElementsByTagName('tr')) {
      if (tr.getElementsByClassName('cell c1').isNotEmpty) {
        String title = tr.getElementsByClassName('cell c1')[0].text.trim();
        String id = tr.getElementsByClassName('cell c1')[0].getElementsByTagName('a')[0].attributes['href']!.split('?id=')[1];
        DateTime? dueDate = DateTime.tryParse(tr.getElementsByClassName('cell c2')[0].text.trim());
        bool done = tr.getElementsByClassName('cell c3')[0].text.trim().contains('완료');

        todoList.add(AssignTodo(
          index: index,
          availability: true,
          courseId: courseId,
          dueDate: dueDate,
          iconUrl: "https://plato.pusan.ac.kr/theme/image.php/coursemosv2/assign/1641196863/icon",
          id: id,
          title: title,
          status: done ? TodoStatus.done : TodoStatus.undone,
          userDefined: false,
          checked: false,
        ));
      }
    }
    return todoList;
  }

  static Future<List<Todo>> _fetchQuiz(final String courseId, int index) async {
    var response = await requestGet(CommonUrl.courseQuizUrl + courseId, isFront: false);

    if (response == null) {
      throw Exception("response is null on _fetchQuiz");
    }

    final List<Todo> todoList = <Todo>[];

    html.Document document = parse(response.data);
    for (var tr in document.getElementsByTagName('tr')) {
      if (tr.getElementsByClassName('cell c1').isNotEmpty) {
        String title = tr.getElementsByClassName('cell c1')[0].text.trim();
        String id = tr.getElementsByClassName('cell c1')[0].getElementsByTagName('a')[0].attributes['href']!.split('?id=')[1];
        DateTime? dueDate = DateTime.tryParse(tr.getElementsByClassName('cell c2')[0].text.trim());
        bool done = tr.getElementsByClassName('cell c3')[0].text.trim().contains('완료') ||
            (tr.getElementsByClassName('cell c3')[0].text.trim() != "-") ||
            dueDate == null ||
            (dueDate.compareTo(DateTime.now()) <= 0);

        todoList.add(QuizTodo(
          index: index,
          availability: true,
          courseId: courseId,
          dueDate: dueDate,
          iconUrl: "https://plato.pusan.ac.kr/theme/image.php/coursemosv2/assign/1641196863/icon",
          id: id,
          title: title,
          status: done ? TodoStatus.done : TodoStatus.undone,
          userDefined: false,
          checked: false,
        ));
      }
    }
    return todoList;
  }

  static Future<List<Todo>> _fetchZoom(final String courseId, int index) async {
    var response = await requestGet(CommonUrl.courseZoomUrl + courseId, isFront: false);

    if (response == null) {
      throw Exception("response is null on _fetchZoom");
    }
    final List<Todo> todoList = <Todo>[];
    html.Document document = parse(response.data);
    for (var tr in document.getElementsByTagName('tr')) {
      if (tr.getElementsByClassName('cell c1').isNotEmpty) {
        String title = tr.getElementsByClassName('cell c1')[0].text.trim();
        String id = tr.getElementsByClassName('cell c1')[0].getElementsByTagName('a')[0].attributes['href']!.split('?id=')[1];
        DateTime? dueDate = DateTime.tryParse(tr.getElementsByClassName('cell c2')[0].text.trim());
        TodoStatus todoStatus = _getZoomTodoStatus(tr);

        if (dueDate == null) {
          var zoom = await CourseZoomController.fetchCourseZoom(id);
          dueDate = zoom!.startTime;
        }

        todoList.add(ZoomTodo(
          index: index,
          availability: true,
          courseId: courseId,
          dueDate: dueDate,
          iconUrl: "https://plato.pusan.ac.kr/theme/image.php/coursemosv2/zoom/1641196863/icon",
          id: id,
          title: title,
          status: todoStatus,
          userDefined: false,
          checked: false,
        ));
      }
    }

    return todoList;
  }

  static TodoStatus _getZoomTodoStatus(final html.Element tr) {
    if (tr.parent!.parent!.classes.contains('mod_index') == false) {
      return TodoStatus.done;
    }
    if (tr.getElementsByClassName('cell c4')[0].getElementsByTagName('form').isNotEmpty) {
      return TodoStatus.doing;
    }
    return TodoStatus.undone;
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

  static String _getIconUri(html.Element activity) {
    return activity.getElementsByTagName('img')[0].attributes['src']!;
  }
}
