import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_zoom_controller.dart';
import 'package:pnu_plato_advanced_browser/data/activity/zoom_course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/course_zoom.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';

class ZoomBottomSheet extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final ZoomCourseActivity activity;
  const ZoomBottomSheet({Key? key, required this.activity, required this.courseTitle, required this.courseId}) : super(key: key);

  Widget _renderZoomInfo() {
    return FutureBuilder<CourseZoom?>(
      future: CourseZoomController.fetchCourseZoom(activity.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
        }

        if (snapshot.data == null) {
          return errorWidget();
        }

        CourseZoom courseZoom = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("시작시간 : ${DateFormat("yyyy-MM-dd HH:mm").format(courseZoom.startTime)} (${courseZoom.runningTime})"),
            Row(
              children: [
                const Text("상태 : "),
                courseZoom.status ? const Icon(Icons.start, color: Colors.green) : const Icon(Icons.close, color: Colors.red)
              ],
            ),
          ],
        );
      },
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
                      imageUrl: activity.iconUrl!,
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
                ],
              ),
              const SizedBox(height: 8.0),
              _renderZoomInfo(),
            ],
          ),
          const Divider(height: 0, thickness: 1.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text("열기"),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () async => await activity.open(context),
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
