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

  Widget _renderZoomInfo(final AsyncSnapshot<CourseZoom?> snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
    }
    if (snapshot.data == null) {
      return errorWidget();
    }

    final CourseZoom courseZoom = snapshot.data!;
    Color textColor = Colors.red;
    switch (courseZoom.status) {
      case "진행중":
        textColor = Colors.green;
        break;
      case "종료":
        textColor = Colors.black;
        break;
      default:
        textColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("시작시간 : ${DateFormat("yyyy-MM-dd HH:mm").format(courseZoom.startTime)} (${courseZoom.runningTime})"),
        Row(
          children: [
            const Text("상태 : "),
            Text(courseZoom.status, style: TextStyle(color: textColor)),
          ],
        ),
      ],
    );
  }

  Widget _renderOpenButton(final BuildContext context, final AsyncSnapshot<CourseZoom?> snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
    }
    if (snapshot.data == null) {
      return errorWidget();
    }

    final CourseZoom courseZoom = snapshot.data!;

    switch (courseZoom.status) {
      case "진행중":
        return TextButton.icon(
          icon: const Icon(Icons.open_in_new),
          label: const Text("열기"),
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            primary: Get.textTheme.bodyText1!.color,
          ),
          onPressed: () async => await activity.open(context),
        );
      default:
        return TextButton.icon(
          icon: const Icon(Icons.open_in_new),
          label: const Text("Zoom이 열려있지 않습니다."),
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            primary: Get.textTheme.bodyText1!.color,
          ),
          onPressed: null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CourseZoom?>(
      future: CourseZoomController.fetchCourseZoom(activity.id),
      builder: (context, snapshot) {
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
                  _renderZoomInfo(snapshot),
                ],
              ),
              const Divider(height: 0, thickness: 1.5),
              Column(
                crossAxisAlignment: snapshot.connectionState == ConnectionState.done ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
                children: [
                  _renderOpenButton(context, snapshot),
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
      },
    );
  }
}
