import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';

class FileBottomSheet extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final CourseFile file;
  final DownloadType fileType;
  const FileBottomSheet({Key? key, required this.file, required this.fileType, required this.courseTitle, required this.courseId}) : super(key: key);

  Future<void> _viewHanlder(BuildContext context) async {
    Navigator.pop(context);
    final BuildContext dialogContext = await showProgressDialog(context, "파일을 다운로드 중입니다...");
    var cachedFile = await DefaultCacheManager().getSingleFile(
      file.url,
      headers: {"Cookie": LoginController.to.loginInformation.moodleSessionKey},
      key: file.url,
    );
    closeProgressDialog(dialogContext);
    var result = await OpenFile.open(cachedFile.path);
    if (result.type != ResultType.done) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: result.message);
    }
  }

  Future<void> _downloadHandler(BuildContext context) async {
    Navigator.pop(context);
    var downloadResult = await DownloadController.enQueue(
      title: file.title,
      url: file.url,
      courseTitle: courseTitle,
      courseId: courseId,
      type: fileType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        runSpacing: 20,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CachedNetworkImage(
                      imageUrl: file.imgUrl,
                      height: 20,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      file.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
          const Divider(height: 0, thickness: 1.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("다운로드"),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () => _downloadHandler(context),
              ),
              TextButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text("열기"),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () => _viewHanlder(context),
              ),
              TextButton.icon(
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('취소'),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
