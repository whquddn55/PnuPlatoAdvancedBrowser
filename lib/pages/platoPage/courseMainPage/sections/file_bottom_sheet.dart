import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
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

  _viewHanlder(BuildContext context) async {
    var cachedFile = await DefaultCacheManager().getSingleFile(
      file.url,
      headers: {"Cookie": Get.find<LoginController>().moodleSessionKey},
      key: '123',
    );
    var result = await OpenFile.open(cachedFile.path);
    if (result.type != ResultType.done) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: result.message);
    }
  }

  _downloadHandler(BuildContext context) async {
    var downloadResult = await Get.find<DownloadController>().enQueue(
      title: file.title,
      url: file.url,
      courseTitle: courseTitle,
      courseId: courseId,
      type: fileType,
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
                    title: file.title,
                    url: file.url,
                    courseTitle: courseTitle,
                    courseId: courseId,
                    type: fileType,
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
                        fontWeight: FontWeight.bold,
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
