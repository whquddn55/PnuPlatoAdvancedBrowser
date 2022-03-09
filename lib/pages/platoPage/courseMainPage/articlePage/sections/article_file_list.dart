import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/file_bottom_sheet.dart';

class ArticleFileList extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final List<CourseFile> fileList;
  const ArticleFileList(this.fileList, this.courseTitle, this.courseId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 0, thickness: 1, color: Colors.grey[700]),
        ...fileList.map<Widget>((fileInfo) {
          return TextButton.icon(
            icon: CachedNetworkImage(imageUrl: fileInfo.imgUrl),
            label: Text(fileInfo.title),
            onPressed: () async {
              showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  builder: (context) => FileBottomSheet(file: fileInfo, fileType: DownloadType.normal, courseTitle: courseTitle, courseId: courseId));
            },
          );
        }).toList()
      ],
    );
  }
}
