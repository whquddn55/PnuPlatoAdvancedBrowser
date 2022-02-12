import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as html;
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/data/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BackgroundServiceAction { login, logout, fetchTodoList, fetchTodoListAll, none }

/* APP 부분 */
class BackgroundService {
  final FlutterBackgroundService service = FlutterBackgroundService();
  Completer<Map<String, dynamic>> loginCompleter = Completer<Map<String, dynamic>>();

  Future<void> initializeService() async {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: _onStart,
        // auto start service
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
        // this will executed when app is in foreground in separated isolate
        onForeground: _onStart,
        // you have to enable background fetch capability on xcode project
        onBackground: _onIosBackground,
      ),
    );

    service.onDataReceived.listen((data) {
      if (data == null) {
        return;
      }

      BackgroundServiceAction action = BackgroundServiceAction.none;
      for (var a in BackgroundServiceAction.values) {
        if (a.toString() == data["action"]) {
          action = a;
        }
      }

      switch (action) {
        case BackgroundServiceAction.login:
          loginCompleter.complete(data["data"]);
          break;
        case BackgroundServiceAction.fetchTodoList:
          break;

        case BackgroundServiceAction.fetchTodoListAll:
          break;

        case BackgroundServiceAction.none:
          assert(false);
          break;
      }
    });
  }

  void sendData(final BackgroundServiceAction action, {Map<String, dynamic>? data}) {
    switch (action) {
      case BackgroundServiceAction.login:
        loginCompleter = Completer();
        break;
    }

    if (data == null) {
      service.sendData({"action": action.toString()});
    } else {
      service.sendData({"action": action.toString(), ...data});
    }
  }
}

/* 서비스 부분 */
void _onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void _onStart() {
  WidgetsFlutterBinding.ensureInitialized();

  /* 데이터 */
  String sessionKey;
  String moddleSessionKey;

  final service = FlutterBackgroundService();
  service.onDataReceived.listen((data) async {
    if (data == null) {
      return;
    }

    BackgroundServiceAction action = BackgroundServiceAction.none;
    for (var a in BackgroundServiceAction.values) {
      if (a.toString() == data["action"]) {
        action = a;
      }
    }

    print("[DEBUG] $data");

    var res = <String, dynamic>{"action": data["action"]};

    switch (action) {
      case BackgroundServiceAction.login:
        res["data"] = await _login(autologin: data["autologin"], username: data["username"], password: data["password"]);
        service.sendData(res);
        break;
      case BackgroundServiceAction.fetchTodoList:
        var courseId = data["courseId"] as String;
        await _TodoController.fetchTodoListByCourseId(courseId);
        service.sendData({"todoList": _TodoController.todoList});
        break;

      case BackgroundServiceAction.fetchTodoListAll:
        await _TodoController.fetchTodoListAll();
        service.sendData({"todoList": _TodoController.todoList});
        break;

      case BackgroundServiceAction.none:
        assert(false);
        break;
    }
  });
}

Future<Map<String, dynamic>> _login({required final bool autologin, String? username, String? password}) async {
  assert(autologin == false ? username != null && password != null : true);
  final Map<String, dynamic> res = <String, dynamic>{};
  final preference = await SharedPreferences.getInstance();
  if (autologin == true) {
    username = preference.getString('username');
    password = preference.getString('password');
  }

  if (username == null || password == null) {
    return {"loginStatus": false, "debugMsg": "username, password가 null임", "loginMsg": "login failed with UnknownError"};
  }

  String body = 'username=$username&password=${Uri.encodeQueryComponent(password)}';
  dio.Response response;
  try {
    response = await dio.Dio().post(CommonUrl.loginUrl,
        data: body,
        options: dio.Options(followRedirects: false, contentType: 'application/x-www-form-urlencoded', headers: {
          'Host': 'plato.pusan.ac.kr',
          'Connection': 'close',
          'Content-Length': body.length.toString(),
          'Cache-Control': 'max-age=0',
          'sec-ch-ua': 'Chromium;v="88", "Google Chrome";v="88", ";Not A Brand";v="99"',
          'sec-ch-ua-mobile': '?0',
          'Upgrade-Insecure-Requests': '1',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36',
          'Origin': 'https://plato.pusan.ac.kr',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
          'Referer': 'https://plato.pusan.ac.kr/',
          'Accept-Encoding': 'gzip, deflate',
          'Accept-Language': 'ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7',
        }));

    /* always return 303 */
    res["debugMsg"] = 'does not return 303';
    res["loginMsg"] = 'login failed with UnknownError';
    /* TODO: popup error report */
    res["loginStatus"] = false;
    return res;
  } on dio.DioError catch (e, _) {
    /* successfully login */
    if (e.response!.statusCode == 303) {
      response = e.response!;
    }
    /* unknownError */
    else {
      res["debugMsg"] = e.toString();
      res["loginMsg"] = 'login failed with UnknownError';
      /* TODO: popup error report */
      res["loginStatus"] = false;
      return res;
    }
  }
  /* unknownError */
  catch (e) {
    res["debugMsg"] = e.toString();
    res["loginMsg"] = 'login failed with UnknownError';
    /* TODO: popup error report */
    res["loginStatus"] = false;
    return res;
  }

  /* wrong id/pw */
  if (response.headers.map['location']![0] == CommonUrl.loginErrorUrl) {
    res["debugMsg"] = 'login failed with wrong ID/PW';
    res["loginMsg"] = '잘못된 ID 또는 PW입니다. 다시 확인해주세요.';
    res["loginStatus"] = false;
    return res;
  }

  /* successfully login */
  res["moodleSessionKey"] = response.headers.map['set-cookie']![1];
  res["debugMsg"] = 'login success';
  res["loginMsg"] = '로그인 성공!';

  print("Synced with Plato");

  _updateSyncTime();
  res.addAll(await _getInformation(res["moodleSessionKey"]));

  await preference.setString('username', username);
  await preference.setString('password', password);

  CookieManager cookieManager = CookieManager.instance();
  await cookieManager.deleteAllCookies();
  await cookieManager.setCookie(
    url: Uri.parse('https://plato.pusan.ac.kr'),
    name: 'MoodleSession',
    value: res["moodleSessionKey"].split('=')[1],
    domain: 'plato.pusan.ac.kr',
    path: '/',
  );
  res["loginStatus"] = true;
  return res;
}

void _updateSyncTime() async {
  final preference = await SharedPreferences.getInstance();
  var now = DateTime.now();
  preference.setString("lastSyncTime", DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString());
}

Future<Map<String, dynamic>> _getInformation(final String moddleSessionKey) async {
  var options = dio.Options(headers: {'Cookie': moddleSessionKey});
  var response = await request(CommonUrl.platoUserInformationUrl, options: options);

  if (response == null) {
    /* TODO: 에러 */

    return {};
  }
  Document document = parse(response.data);

  final res = <String, dynamic>{};
  res["studentId"] = int.parse(document.getElementById('fitem_id_idnumber')!.children[1].text.trim());
  res["department"] = document.getElementById('fitem_id_department')!.children[1].text.trim();
  res["name"] = document.getElementById('id_firstname')!.attributes['value']!.trim();
  res["imgUrl"] = document.getElementsByClassName('userpicture')[0].attributes['src']!;

  return res;
}

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

    var options = dio.Options(headers: {'Cookie': Get.find<UserDataController>().moodleSessionKey});
    var response = await request(CommonUrl.courseMainUrl + courseId, options: options, callback: Get.find<UserDataController>().login);
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
    var options = dio.Options(headers: {'Cookie': Get.find<UserDataController>().moodleSessionKey});
    var response = await request(CommonUrl.courseAssignUrl + courseId, options: options, callback: Get.find<UserDataController>().login);

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
    var options = dio.Options(headers: {'Cookie': Get.find<UserDataController>().moodleSessionKey});
    var response = await request(CommonUrl.courseQuizUrl + courseId, options: options, callback: Get.find<UserDataController>().login);

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
