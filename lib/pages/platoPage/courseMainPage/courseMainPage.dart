import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/courseController.dart';
import 'package:pnu_plato_advanced_browser/data/activity.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/data/courseArticle.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/articlePage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/boradPage/boardPage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/gradePage/gradePage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/plannerPage/plannerPage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/onlineAbsencePage/onlineAbsencePage.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/smartAbsencePage/smartAbsencePage.dart';

class CourseMainPage extends StatefulWidget {
  final Course course;

  const CourseMainPage({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseMainPage> createState() => _CourseMainPageState();
}

class _CourseMainPageState extends State<CourseMainPage> {
  final _scrollController = ScrollController();
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
              title: Text('${widget.course.title} - ${widget.course.professor!.name}'),
              centerTitle: true,
              leading: const BackButton(),
            ),
            endDrawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(widget.course.professor!.name),
                    accountEmail: null,
                    currentAccountPicture: CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.course.professor!.iconUri.toString())),
                    otherAccountsPictures: [
                      IconButton(
                        icon: Icon(Icons.email, color: Get.theme.primaryIconTheme.color),
                        onPressed: () {
                          print('show message page');
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('팀티칭/조교'),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.course.assistantList.map((assistant) {
                      return TextButton.icon(
                        icon: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(assistant.iconUri.toString()),
                        ),
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              assistant.name,
                              style: TextStyle(color: Get.textTheme.bodyText1!.color),
                            ),
                            Text(
                              assistant.type,
                              style: TextStyle(color: Get.textTheme.bodyText1!.color),
                            ),
                          ],
                        ),
                        style: TextButton.styleFrom(
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () {},
                      );
                    }).toList(),
                  ),
                  const Divider(height: 0, thickness: 1),
                  ListTile(
                    title: const Text('국문 계획표'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlannerPage(
                            title: '국문 계획표',
                            uri: widget.course.koreanPlanUri,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('영문 계획표'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlannerPage(
                            title: '영문 계획표',
                            uri: widget.course.englishPlanUri,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 0, thickness: 1),
                  ListTile(
                    title: const Text('온라인 출석부'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OnlineAbsencePage(courseId: widget.course.id),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('스마트 출석부'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SmartAbsencePage(courseId: widget.course.id),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('성적부'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GradePage(courseId: widget.course.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              controller: _scrollController,
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
                      headerPadding: EdgeInsets.all(10.0),
                      headerColor: Color(0xfff3f2dd),
                      headerRadius: 0.0,
                      contentRadius: 0.0,
                    ),
                    contentSeperator: 0,
                    title: const Text(
                      '공지사항',
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.black87),
                    content: Container(
                      padding: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xfff3f2dd),
                        border: Border.all(
                          color: const Color(0xffdad9c6),
                        ),
                      ),
                      child: Column(
                        children: widget.course.articleList.map((article) {
                          return _articleButton(article);
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
                            contentBackgroundColor: Get.theme.scaffoldBackgroundColor,
                          ),
                          contentSeperator: 0,
                          title: Text(key),
                          content: Material(
                            child: Column(
                              children: [
                                widget.course.summaryMap[key] == ''
                                    ? const SizedBox.shrink()
                                    : Container(
                                        child: renderHtml(widget.course.summaryMap[key]!),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: Get.theme.hintColor),
                                          borderRadius: BorderRadius.circular(3.0),
                                        ),
                                        margin: const EdgeInsets.only(bottom: 20.0),
                                      ),
                                Column(
                                  children: widget.course.activityMap[key]!.map((activity) {
                                    return _activityButton(activity);
                                  }).toList(),
                                ),
                              ],
                            ),
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

  Widget _articleButton(CourseArticle article) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticlePage(article: article)));
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              '-',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
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
    );
  }

  Widget _activityButton(Activity activity) {
    bool avilablity = activity.iconUri != null && activity.availablility == true;
    return InkWell(
      onTap: avilablity == false
          ? null
          : () {
              if (activity.type == 'ubboard') {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BoardPage(boardId: activity.id)));
              } else if (activity.type == 'vod') {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _vodBottomSheet(context, activity),
                  useRootNavigator: true,
                );
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

  Widget _vodBottomSheet(BuildContext context, Activity activity) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Row(
                children: [
                  const Text('출석 상태: '),
                  Icon(
                    Icons.check,
                    color: Colors.lightGreen,
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 0, thickness: 1.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('다운로드'),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {},
              ),
              TextButton.icon(
                icon: const Icon(Icons.videocam),
                label: const Text('재생'),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {},
              ),
              TextButton.icon(
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('취소'),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
