import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';

class ArticlePage extends StatelessWidget {
  final CourseArticle article;
  final String courseTitle;
  final String courseId;

  const ArticlePage({
    Key? key,
    required this.article,
    required this.courseTitle,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<CourseController>().getArticleInfo(article),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: Text(data['main']!),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(height: 0, thickness: 1.5, color: Colors.black),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Flexible(
                            child: Center(
                              child: Text(
                                data['title']!,
                                style: Get.textTheme.subtitle1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Divider(height: 0, thickness: 1, color: Colors.grey[700]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['writer']!),
                          Text(data['date']!),
                        ],
                      ),
                    ),
                    Divider(height: 0, thickness: 1, color: Colors.grey[700]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data["files"].map<Widget>((fileInfo) {
                        return TextButton.icon(
                          icon: CachedNetworkImage(imageUrl: fileInfo[2]),
                          label: Text(fileInfo[0]),
                          onPressed: () async {
                            var downloadResult = await Get.find<DownloadController>().enQueue(
                              url: fileInfo[1],
                              title: fileInfo[0],
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
                                            url: fileInfo[1],
                                            title: fileInfo[0],
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
                      }).toList(),
                    ),
                    Divider(height: 0, thickness: 1, color: Colors.grey[700]),
                    renderHtml(data['content']!),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: '로딩중 ...'));
        }
      },
    );
  }
}
