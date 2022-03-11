import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/todo_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/gradePage/grade_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/plannerPage/planner_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/onlineAbsencePage/online_absence_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/activity_button.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/article_button.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/smartAbsencePage/smart_absence_page.dart';

class CourseMainPage extends StatelessWidget {
  final Course course;

  const CourseMainPage({Key? key, required this.course}) : super(key: key);

  void _refreshTodoList(final Map<int, List<Map<String, dynamic>>> vodStatusMap) {
    List<Map<String, dynamic>> vodStatusList = [];
    for (var values in vodStatusMap.values) {
      for (var vodStatus in values) {
        vodStatusList.add(vodStatus);
      }
    }

    TodoController.to.refreshTodoList([course.id], vodStatusList);
  }

  Widget _renderEndDrawer(final BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(course.professor!.name),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(backgroundImage: CachedNetworkImageProvider(course.professor!.iconUri.toString())),
            otherAccountsPictures: [
              IconButton(
                icon: Icon(Icons.email, color: Get.theme.primaryIconTheme.color),
                onPressed: () {
                  /* TODO: 메시지 페이지로 이동 */
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('팀티칭/조교'),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            children: course.assistantList.map((assistant) {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlannerPage(
                    title: '국문 계획표',
                    uri: course.koreanPlanUri,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('영문 계획표'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlannerPage(
                    title: '영문 계획표',
                    uri: course.englishPlanUri,
                  ),
                ),
              );
            },
          ),
          const Divider(height: 0, thickness: 1),
          ListTile(
            title: const Text('온라인 출석부'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OnlineAbsencePage(courseId: course.id),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('스마트 출석부'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SmartAbsencePage(courseId: course.id),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('성적부'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GradePage(courseId: course.id),
                  ));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _articleTileController = ExpandedTileController();
    final _weekTileControllerList = <ExpandedTileController>[];

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([Get.find<CourseController>().updateCourseSpecification(course), Get.find<CourseController>().getVodStatus(course.id)]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: '강의 정보를 로딩 중입니다...'));
        }

        for (var i = 0; i < course.activityMap.keys.length; ++i) {
          _weekTileControllerList.add(ExpandedTileController());
        }

        _refreshTodoList(snapshot.data![1]);

        return Scaffold(
          appBar: AppBar(
            title: Text('${course.title} - ${course.professor!.name}'),
            centerTitle: true,
            leading: const BackButton(),
          ),
          endDrawer: _renderEndDrawer(context),
          body: ListView(
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
                    children:
                        course.articleList.map((article) => ArticleButton(article: article, courseTitle: course.title, courseId: course.id)).toList(),
                  ),
                ),
              ),
              ...course.activityMap.keys.map((key) {
                int index = course.activityMap.keys.toList().indexOf(key);

                if (course.currentWeek != null) {
                  int currentWeekIndex = course.activityMap.keys.toList().indexOf(course.currentWeek!);
                  _weekTileControllerList[currentWeekIndex].expand();
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
                      content: Column(
                        children: [
                          course.summaryMap[key] == ''
                              ? const SizedBox.shrink()
                              : Container(
                                  child: renderHtml(course.summaryMap[key]!),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Get.theme.hintColor),
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 20.0),
                                ),
                          Column(
                            children: course.activityMap[key]!.fold<List<Widget>>([], (prv, activity) {
                              prv.addAll([const Divider(), ActivityButton(activity: activity, courseTitle: course.title, courseId: course.id)]);
                              return prv;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
