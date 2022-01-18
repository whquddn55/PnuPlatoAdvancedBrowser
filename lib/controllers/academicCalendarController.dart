import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/acamedicCalendarItem.dart';

class AcademicCalendarController {
  static Future<List<AcademicCalendarItem>?> getAcademicCalendar() async {
    var response = await request(CommonUrl.academicCalendarUrl);
    if (response == null) {
      /* TODO: 에러 */
      return null;
    }

    Document document = parse(response.data);
    List<AcademicCalendarItem> res = <AcademicCalendarItem>[];
    for (int i = 1; i < document.getElementsByTagName('tr').length; ++i) {
      var tr = document.getElementsByTagName('tr')[i];
      res.add( AcademicCalendarItem(
          title: tr.children[1].text,
          dateFrom: tr.children[0].text.split(' - ')[0],
          dateTo: tr.children[0].text.split(' - ')[1]
      ));
    }
    return res;
  }
}