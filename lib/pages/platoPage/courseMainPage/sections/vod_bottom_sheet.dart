import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/vodPage/vod_page.dart';

class VodBottomSheet extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final CourseActivity activity;
  const VodBottomSheet({Key? key, required this.activity, required this.courseTitle, required this.courseId}) : super(key: key);

  _viewHanlder(BuildContext context) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (context) => VodPage(id: activity.id)));
  }

  _downloadHandler(BuildContext context) async {
    Uri uri = await Get.find<CourseController>().getM3u8Uri(activity.id);
    if (uri.toString() == '') {
    } else {
      var downloadResult = await Get.find<DownloadController>().enQueue(
        url: uri.toString(),
        title: activity.title,
        courseTitle: courseTitle,
        courseId: courseId,
        type: DownloadType.m3u8,
      );
      if (downloadResult == DownloadQueueingStatus.denied) {
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
                      url: uri.toString(),
                      title: activity.title,
                      courseTitle: courseTitle,
                      courseId: courseId,
                      type: DownloadType.m3u8,
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
                      imageUrl: activity.iconUri!.toString(),
                      height: 20,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      activity.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    activity.info,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              if (activity.startDate != null)
                if (activity.lateDate != null)
                  Text(
                    '${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.startDate!)} ~ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.endDate!)}\n(지각: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.lateDate!)})',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                    ),
                  )
                else
                  Text(
                    '${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.startDate!)} ~ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.endDate!)}',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                    ),
                  ),
              const SizedBox(height: 8.0),
              FutureBuilder(
                future: Get.find<CourseController>().getVodStatus(activity.courseId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data as Map<int, List<Map<String, dynamic>>>;
                    Widget? status;
                    for (var weeks in data.values) {
                      for (var activities in weeks) {
                        if (activities["title"] == activity.title) {
                          if (activities["status"] == true) {
                            status = const Icon(
                              Icons.check,
                              color: Colors.lightGreen,
                            );
                          } else {
                            status = const Icon(
                              Icons.close,
                              color: Colors.red,
                            );
                          }
                        }
                      }
                    }
                    if (status == null) {
                      return const SizedBox.shrink();
                    } else {
                      return Row(
                        children: [
                          const Text('출석 상태: '),
                          status,
                        ],
                      );
                    }
                  } else {
                    return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
                  }
                },
              ),
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
