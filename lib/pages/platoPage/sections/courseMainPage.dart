import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/courseController.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';

class CourseMainPage extends StatefulWidget {
  final Course course;

  const CourseMainPage({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseMainPage> createState() => _CourseMainPageState();
}

class _CourseMainPageState extends State<CourseMainPage> {
  final _articleTileController = ExpandedTileController();
  final _weekTileControllerList = List<ExpandedTileController>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<CourseController>().updateCourseSpecification(widget.course),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${widget.course.title} - ${widget.course.professor?.name}'),
              centerTitle: true,
              leading: const BackButton(),
            ),
            endDrawer: Drawer(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ExpandedTile(
                    onTap: () {
                      for (var controller in _weekTileControllerList) {
                        controller.collapse();
                      }
                    },
                    controller: _articleTileController,
                    theme: const ExpandedTileThemeData(
                      headerPadding: EdgeInsets.all(3.0),
                      headerColor: Color(0xfff3f2dd),
                      headerRadius: 0.0,
                      contentRadius: 0.0,
                    ),
                    contentSeperator: 0,
                    title: const Text('공지사항'),
                    content: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xfff3f2dd),
                        border: Border.all(
                          color: const Color(0xffdad9c6),
                        ),
                      ),
                      child: Column(
                        children: widget.course.articleList.map((article) {
                          return TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                              backgroundColor: Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                const Expanded(flex: 3, child: Text('-')),
                                Expanded(
                                  flex: 100,
                                  child: NFMarquee(
                                    text: article.title,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 25,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      article.date,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {},
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  ...widget.course.activityMap.keys.map((key) {
                    int index = widget.course.activityMap.keys.toList().indexOf(key);
                    while (_weekTileControllerList.length <= index) {
                      _weekTileControllerList.add(ExpandedTileController());
                    }
                    return Column(
                      children: [
                        const Divider(
                          height: 3,
                          thickness: 3,
                        ),
                        ExpandedTile(
                          onTap: () {
                            for (var controller in _weekTileControllerList) {
                              if (controller != _weekTileControllerList[index]) {
                                controller.collapse();
                              }
                            }
                            _articleTileController.collapse();
                          },
                          controller: _weekTileControllerList[index],
                          theme: ExpandedTileThemeData(
                            headerPadding: const EdgeInsets.all(3.0),
                            headerColor: Get.theme.secondaryHeaderColor,
                            headerRadius: 0.0,
                            contentRadius: 0.0,
                            contentBackgroundColor: Colors.grey[100],
                          ),
                          contentSeperator: 0,
                          title: Text(key),
                          content: Column(
                            children: [
                              widget.course.summaryMap[key] == ''
                                  ? const SizedBox.shrink()
                                  : Container(
                                      child: renderHtml(widget.course.summaryMap[key]!),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(3.0),
                                      ),
                                    ),
                              Column(
                                children: widget.course.activityMap[key]!.map((activity) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(right: 10),
                                              child: CachedNetworkImage(
                                                imageUrl: activity.iconUri.toString(),
                                                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 1),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            Text(activity.title),
                                            Text(
                                              activity.info ?? '',
                                              style: const TextStyle(
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                        renderHtml(activity.description),
                                      ],
                                    ),
                                    onTap: () {
                                      print(activity.title);
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        } else {
          return const LoadingPage(msg: '강의 정보를 로딩 중입니다...');
        }
      },
    );
  }
}
