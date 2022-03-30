import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/academic_calendar_controller.dart';
import 'package:pnu_plato_advanced_browser/data/acamedic_calendar_item.dart';

class AcademicCalendar extends StatelessWidget {
  const AcademicCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _expandedTileController = ExpandedTileController();
    return FutureBuilder(
        future: AcademicCalendarController.getAcademicCalendar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return ExpandedTile(
                  theme: ExpandedTileThemeData(
                      headerPadding: const EdgeInsets.all(3.0),
                      headerColor: Get.theme.secondaryHeaderColor,
                      headerRadius: 0.0,
                      contentPadding: EdgeInsets.zero,
                      contentRadius: 0.0,
                      contentBackgroundColor: Colors.transparent),
                  controller: _expandedTileController,
                  title: const Text('학사일정(최근 60일)'),
                  content: Center(
                    child: Text('일정을 불러오는데 문제가 발생했습니다.',
                        style: TextStyle(
                          color: Get.theme.errorColor,
                        )),
                  ));
            }
            
            var data = snapshot.data as List<AcademicCalendarItem>;
            return ExpandedTile(
                theme: ExpandedTileThemeData(
                    headerPadding: const EdgeInsets.all(3.0),
                    headerColor: Get.theme.secondaryHeaderColor,
                    headerRadius: 0.0,
                    contentPadding: EdgeInsets.zero,
                    contentRadius: 0.0,
                    contentBackgroundColor: Colors.transparent),
                controller: _expandedTileController,
                title: const Text('학사일정(최근 60일)'),
                content: Column(
                  children: [
                    for (var item in data)
                      if (DateTime.parse(item.dateTo.replaceAll('.', '-')).difference(DateTime.now()).inDays <= 60) ...[
                        SizedBox(
                          height: 20,
                          child: ListTile(
                            leading: Text(
                              '${item.dateFrom} ~ ${item.dateTo}',
                              style: const TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                            title: Text(item.title,
                                overflow: TextOverflow.ellipsis, style: const TextStyle(height: -0.3, fontSize: 10), textAlign: TextAlign.center),
                          ),
                        ),
                      ]
                  ],
                ));
          } else {
            return ExpandedTile(
                theme: ExpandedTileThemeData(
                    headerPadding: const EdgeInsets.all(3.0),
                    headerColor: Get.theme.secondaryHeaderColor,
                    headerRadius: 0.0,
                    contentPadding: EdgeInsets.zero,
                    contentRadius: 0.0,
                    contentBackgroundColor: Colors.transparent),
                controller: _expandedTileController,
                title: const Text('학사일정(최근 60일)'),
                content: const Center(child: Text('일정을 불러오는 중입니다.')));
          }
        });
  }
}
