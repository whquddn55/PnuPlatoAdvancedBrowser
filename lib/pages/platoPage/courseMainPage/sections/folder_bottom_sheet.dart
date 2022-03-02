import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_folder_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_activity.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';
import 'package:pnu_plato_advanced_browser/data/course_folder_file.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/file_bottom_sheet.dart';

class FolderBottomSheet extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final CourseActivity activity;
  const FolderBottomSheet({Key? key, required this.activity, required this.courseTitle, required this.courseId}) : super(key: key);

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
          FutureBuilder<List<CourseFolderFile>>(
              future: CourseFolderController.fetchCourseFolderFileList(activity.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.data == null) {
                    return Row(
                      children: [
                        SvgPicture.asset("assets/icons/lobster.svg"),
                        const Text("어라..랍스타? 에러가 났어요"),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: snapshot.data!
                          .map(
                            (file) => TextButton.icon(
                                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                                icon: CachedNetworkImage(imageUrl: file.imgUrl),
                                label: Text(file.title),
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => FileBottomSheet(
                                          file: CourseFile(imgUrl: file.imgUrl, url: file.url, title: file.title),
                                          fileType: DownloadType.normal,
                                          courseTitle: courseTitle,
                                          courseId: courseId));
                                }),
                          )
                          .toList(),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}
