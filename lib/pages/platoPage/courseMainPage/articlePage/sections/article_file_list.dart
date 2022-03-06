import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';

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
              var downloadResult = await Get.find<DownloadController>().enQueue(
                url: fileInfo.url,
                title: fileInfo.title,
                courseTitle: courseTitle,
                courseId: courseId,
                type: DownloadType.normal,
                force: false,
              );
            },
          );
        }).toList()
      ],
    );
  }
}
