import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/activity/vod_course_activity.dart';

class VodBottomSheet extends StatefulWidget {
  final String courseTitle;
  final String courseId;
  final VodCourseActivity activity;
  const VodBottomSheet({Key? key, required this.activity, required this.courseTitle, required this.courseId}) : super(key: key);

  @override
  State<VodBottomSheet> createState() => _VodBottomSheetState();
}

class _VodBottomSheetState extends State<VodBottomSheet> {
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
                      imageUrl: widget.activity.iconUrl!,
                      height: 20,
                      errorWidget: (buildContext, url, error) =>
                          SvgPicture.asset("assets/icons/lobster.svg", height: 25, width: 25, color: Colors.red),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.activity.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
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
                    '${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.activity.startDate!)} ~ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.activity.endDate!)}\n(??????: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.activity.lateDate!)})',
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
                future: TodoController.to.updateVodTodoStatus(widget.courseId),
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
                        const Text('?????? ??????: '),
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
                label: const Text("????????????"),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () async {
                  widget.activity.download();
                  Navigator.pop(context);
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text("??????"),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () async {
                  await widget.activity.open(context);
                  setState(() {});
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('??????'),
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
