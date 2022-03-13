import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/vodPage/vod_page.dart';

class VodBottomSheet extends StatefulWidget {
  final String courseTitle;
  final String courseId;
  final CourseActivity activity;
  const VodBottomSheet({Key? key, required this.activity, required this.courseTitle, required this.courseId}) : super(key: key);

  @override
  State<VodBottomSheet> createState() => _VodBottomSheetState();
}

class _VodBottomSheetState extends State<VodBottomSheet> {
  late final Future _future;

  @override
  initState() {
    super.initState();
    _future = CourseController.getVodStatus(widget.courseId, true).then((value) async {
      await TodoController.to.updateTodoStatus(value);
      return value;
    });
  }

  _viewHanlder(BuildContext context) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (context) => VodPage(id: widget.activity.id)));
  }

  _downloadHandler(BuildContext context) async {
    Uri uri = await CourseController.getM3u8Uri(widget.activity.id);
    if (uri.toString() == '') {
    } else {
      var downloadResult = await Get.find<DownloadController>().enQueue(
        url: uri.toString(),
        title: widget.activity.title,
        courseTitle: widget.courseTitle,
        courseId: widget.courseId,
        type: DownloadType.m3u8,
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
                      imageUrl: widget.activity.iconUri!.toString(),
                      height: 20,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.activity.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    widget.activity.info,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              if (widget.activity.startDate != null)
                if (widget.activity.lateDate != null)
                  Text(
                    '${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.activity.startDate!)} ~ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.activity.endDate!)}\n(지각: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.activity.lateDate!)})',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                    ),
                  )
                else
                  Text(
                    '${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.activity.startDate!)} ~ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.activity.endDate!)}',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                    ),
                  ),
              const SizedBox(height: 8.0),
              FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
                  }
                  var data = snapshot.data as Map<int, List<Map<String, dynamic>>>;

                  Widget? status;
                  for (var weeks in data.values) {
                    for (var activities in weeks) {
                      if (activities["title"] == widget.activity.title) {
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
