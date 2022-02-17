import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';

class ArticleFileList extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final List<CourseArticleFile> fileList;
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
                type: DownloadType.articleAttach,
                force: false,
              );

              if (downloadResult == DownloadQueueingStatus.denied) {
                Fluttertoast.cancel();
                Fluttertoast.showToast(msg: '다운 받기 위해서는 권한이 필요합니다.');
              } else if (downloadResult == DownloadQueueingStatus.permanentlyDenied) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text("앱 세팅 화면에서 권한을 모두 허용으로 바꾸어 주세요."),
                    );
                  },
                );
                openAppSettings();
              } else if (downloadResult == DownloadQueueingStatus.duplicated) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text("이미 존재하는 파일입니다. 다시 다운로드 받으시겠습니까?"),
                      actions: [
                        TextButton(
                          child: const Text("취소"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: const Text("덮어쓰기"),
                          onPressed: () async {
                            await Get.find<DownloadController>().enQueue(
                              url: fileInfo.url,
                              title: fileInfo.title,
                              courseTitle: courseTitle,
                              courseId: courseId,
                              type: DownloadType.articleAttach,
                              force: true,
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );
        }).toList()
      ],
    );
  }
}
