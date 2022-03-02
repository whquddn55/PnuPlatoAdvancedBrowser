import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/course_folder_file.dart';

abstract class CourseFolderController {
  static Future<List<CourseFolderFile>> fetchCourseFolderFileList(final String folderId) async {
    var res = await requestGet(CommonUrl.courseFolderViewUrl + folderId, isFront: true);

    if (res == null) {
      return [];
    }

    Document document = Document.html(res.data);

    final List<CourseFolderFile> fileList = [];
    for (var fileInstance in document.getElementsByClassName('fp-filename-icon')) {
      if (fileInstance.getElementsByTagName('a').isEmpty) continue;

      fileList.add(CourseFolderFile(
        imgUrl: fileInstance.getElementsByTagName('img')[0].attributes['src']!,
        url: fileInstance.getElementsByTagName('a')[0].attributes['href']!,
        title: fileInstance.getElementsByClassName('fp-filename')[0].text,
      ));
    }

    return fileList;
  }
}
