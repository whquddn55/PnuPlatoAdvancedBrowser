import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/activity.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/assignPage/AssignPage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/boradPage/board_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/file_bottom_sheet.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/link_bottom_sheet.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/vod_bottom_sheet.dart';

class ActivityButton extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final Activity activity;
  const ActivityButton({Key? key, required this.activity, required this.courseTitle, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool avilablity = activity.iconUri != null && activity.availablility == true;
    return InkWell(
      onTap: avilablity == false
          ? null
          : () async {
              if (activity.type == 'ubboard') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => BoardPage(boardId: activity.id, courseTitle: courseTitle, courseId: courseId)));
              } else if (activity.type == 'vod') {
                //Get.find<RouteController>().showBottomNavBar = false;
                await showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    builder: (context) => VodBottomSheet(activity: activity, courseTitle: courseTitle, courseId: courseId));
                //Get.find<RouteController>().showBottomNavBar = true;
              } else if (activity.type == 'ubfile') {
                //Get.find<RouteController>().showBottomNavBar = false;
                await showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    builder: (context) => FileBottomSheet(activity: activity, courseTitle: courseTitle, courseId: courseId));
                //Get.find<RouteController>().showBottomNavBar = true;
              } else if (activity.type == 'assign') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AssignPage(assignId: activity.id)));
              } else if (activity.type == 'url') {
                showModalBottomSheet(context: context, useRootNavigator: true, builder: (context) => LinkBottomSheet(activity: activity));
              }
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: activity.iconUri == null
                      ? const SizedBox.shrink()
                      : Opacity(
                          opacity: avilablity == false ? 0.5 : 1.0,
                          child: CachedNetworkImage(
                            imageUrl: activity.iconUri.toString(),
                            placeholder: (context, url) => const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 1),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            height: 20,
                            width: 20,
                          ),
                        ),
                ),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: activity.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.textTheme.bodyText2!.color!.withOpacity(avilablity == false ? 0.5 : 1.0),
                      ),
                      children: [
                        TextSpan(
                          text: '   ${activity.info}',
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        if (activity.startDate != null)
                          if (activity.lateDate != null)
                            TextSpan(
                              text:
                                  '\n${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.startDate!)} ~ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.endDate!)}\n(지각: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.lateDate!)})',
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          else
                            TextSpan(
                              text:
                                  '\n${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.startDate!)} ~ ${DateFormat('yyyy-MM-dd HH:mm:ss').format(activity.endDate!)}',
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (activity.availablilityInfo != '') renderHtml(activity.availablilityInfo),
            if (activity.description != '') renderHtml(activity.description)
          ],
        ),
      ),
    );
  }
}
