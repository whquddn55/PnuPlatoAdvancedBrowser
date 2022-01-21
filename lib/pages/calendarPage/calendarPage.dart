import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/academicCalendarController.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/data/acamedicCalendarItem.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/AcademicCalendar.dart';
import 'package:pnu_plato_advanced_browser/pages/calendarPage/sections/mainCalendar.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';
import 'package:pnu_plato_advanced_browser/pages/navigatorPage/sections/drawer.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final List<AcademicCalendarItem>? _academicCalendar;
  late final Future<bool> _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = _fetchCalendars();
  }

  Future<bool> _fetchAcademicCalendar() async {
    _academicCalendar = await AcademicCalendarController.getAcademicCalendar();
    return _academicCalendar != null;
  }

  Future<bool> _fetchCalendars() async {
    bool res = await _fetchAcademicCalendar();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('캘린더'),
        centerTitle: true,
      ),
      drawer: const MainDrawer(),
      body: GetBuilder<UserDataController>(
        builder: (controller) {
          if (controller.loginStatus == false) {
            return Builder(builder: (context) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: const Center(
                    child: Text(
                  '로그인이 필요합니다.',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                )),
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            });
          } else {
            return FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          AcademicCalendar(itemList: _academicCalendar),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MainCalendar(),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const LoadingPage(msg: '캘린더를 불러오는 중입니다...');
                  }
                });
          }
        },
      ),
    );
  }
}
