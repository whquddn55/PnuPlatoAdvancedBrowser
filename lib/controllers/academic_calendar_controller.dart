import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/data/acamedic_calendar_item.dart';

abstract class AcademicCalendarController {
  static Future<List<AcademicCalendarItem>?> getAcademicCalendar() async {
    var response = await requestGet(CommonUrl.academicCalendarUrl, isFront: true);
    if (response == null) {
      ExceptionController.onExpcetion("response on getAcademicCalendar is null", true);
      return null;
    }
    if (response.requestOptions.path == "null") {
      return null;
    }

    try {
      Document document = parse(response.data);
      List<AcademicCalendarItem> res = <AcademicCalendarItem>[];
      for (int i = 1; i < document.getElementsByTagName('tr').length; ++i) {
        var tr = document.getElementsByTagName('tr')[i];
        res.add(AcademicCalendarItem(
            title: tr.children[1].text, dateFrom: tr.children[0].text.split(' - ')[0], dateTo: tr.children[0].text.split(' - ')[1]));
      }
      return res;
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + "\n" + stacktrace.toString(), true);
    }
    return null;
  }
}
