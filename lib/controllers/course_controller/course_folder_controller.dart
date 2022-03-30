import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';

abstract class CourseFolderController {
  static Future<List<CourseFile>> fetchCourseFolderFileList(final String folderId) async {
    var res = await requestGet(CommonUrl.courseFolderViewUrl + folderId, isFront: true);

    if (res == null) {
      ExceptionController.onExpcetion("response is null on fetchCourseFileList", true);
      return [];
    }
    if (res.requestOptions.path == "null") {
      return [];
    }

    try {
      Document document = Document.html(res.data);

      final List<CourseFile> fileList = [];
      for (var fileInstance in document.getElementsByClassName('fp-filename-icon')) {
        if (fileInstance.getElementsByTagName('a').isEmpty) continue;

        fileList.add(CourseFile(
          imgUrl: fileInstance.getElementsByTagName('img')[0].attributes['src']!,
          url: fileInstance.getElementsByTagName('a')[0].attributes['href']!,
          title: fileInstance.getElementsByClassName('fp-filename')[0].text,
        ));
      }

      return fileList;
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + "\n" + stacktrace.toString(), true);
    }
    return [];
  }
}
