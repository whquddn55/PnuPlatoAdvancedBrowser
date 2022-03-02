import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_activity.dart';
import 'package:pnu_plato_advanced_browser/inappwebview_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkBottomSheet extends StatelessWidget {
  final CourseActivity activity;
  const LinkBottomSheet({Key? key, required this.activity}) : super(key: key);

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
            ],
          ),
          const Divider(height: 0, thickness: 1.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.open_in_browser),
                label: const BetaBadge(
                    child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Text("내부 브라우저로 열기"),
                )),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => InappwebviewWrapper(activity.title, CommonUrl.courseUrlViewUrl + activity.id + '&redirect=1', null))),
              ),
              TextButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text("외부 브라우저로 열기"),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () {
                  launch(CommonUrl.courseUrlViewUrl + activity.id + '&redirect=1', headers: {"Cookie": Get.find<LoginController>().moodleSessionKey});
                },
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
