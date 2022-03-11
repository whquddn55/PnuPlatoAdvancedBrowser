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

class CourseMainPage extends StatefulWidget {
  final Course course;
  final String? targetActivityId;

  const CourseMainPage({Key? key, required this.course, this.targetActivityId}) : super(key: key);

  @override
  State<CourseMainPage> createState() => _CourseMainPageState();
}

class _CourseMainPageState extends State<CourseMainPage> {
  final _articleTileController = ExpandedTileController();
  final _weekTileControllerList = <ExpandedTileController>[];

  void _refreshTodoList() async {
    final vodStatusMap = await Get.find<CourseController>().getVodStatus(widget.course.id);
    List<Map<String, dynamic>> vodStatusList = [];
    for (var values in vodStatusMap.values) {
      for (var vodStatus in values) {
        vodStatusList.add(vodStatus);
      }
    }

    TodoController.to.refreshTodoList([widget.course.id], vodStatusList);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _articleTileController.dispose();
    for (var controller in _weekTileControllerList) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<CourseController>().updateCourseSpecification(widget.course),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: '강의 정보를 로딩 중입니다...'));

        _refreshTodoList();

        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.course.title} - ${widget.course.professor!.name}'),
            centerTitle: true,
            leading: const BackButton(),
          ),
          endDrawer: _renderEndDrawer(context),
          body: ListView(
            children: [
              _renderArticleList(),
              ..._renderWeekTileList(),
            ],
          ),
        );
      },
    );
  }

  Widget _renderEndDrawer(final BuildContext context) {
    return Drawer(
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
                  /* TODO: 메시지 페이지로 이동 */
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
              Navigator.push(
                context,
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
              Navigator.push(
                context,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OnlineAbsencePage(courseId: widget.course.id),
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
                  builder: (context) => SmartAbsencePage(courseId: widget.course.id),
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
                    builder: (context) => GradePage(courseId: widget.course.id),
                  ));
            },
          ),
        ],
      ),
    );
  }

  Widget _renderArticleList() {
    return ExpandedTile(
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
          children: widget.course.articleList
              .map((article) => ArticleButton(article: article, courseTitle: widget.course.title, courseId: widget.course.id))
              .toList(),
        ),
      ),
    );
  }

  List<Widget> _renderWeekTileList() {
    final targetActivityKey = GlobalKey();
    final currenrWeekKey = GlobalKey();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.targetActivityId != null) {
        if (targetActivityKey.currentContext == null) return;
        Scrollable.ensureVisible(targetActivityKey.currentContext!, alignment: 0.5, duration: const Duration(milliseconds: 500));
      } else {
        Scrollable.ensureVisible(currenrWeekKey.currentContext!, duration: const Duration(milliseconds: 500));
      }
    });

    final currentWeekIndex = widget.course.activityMap.keys.toList().indexOf(widget.course.currentWeek!);
    final List<Widget> weekTileWidgetList = [];
    final weekList = widget.course.activityMap.values.toList();
    for (int weekIndex = 0; weekIndex < weekList.length; ++weekIndex) {
      final week = weekList[weekIndex];
      final weekTitle = widget.course.activityMap.keys.toList()[weekIndex];

      bool isTargetWeek = false;
      /* Build activityButtons */
      final List<Widget> activityButtonList = [];
      for (int activityIndex = 0; activityIndex < week.length; ++activityIndex) {
        final activity = week[activityIndex];

        activityButtonList.addAll([
          const Divider(),
          ActivityButton(
            key: (activity.id == widget.targetActivityId) ? targetActivityKey : null,
            activity: activity,
            courseTitle: widget.course.title,
            courseId: widget.course.id,
            isTarget: (activity.id == widget.targetActivityId),
          ),
        ]);

        if (activity.id == widget.targetActivityId) {
          isTargetWeek = true;
        }
      }

      _weekTileControllerList.add(ExpandedTileController());

      if (widget.targetActivityId != null) {
        if (isTargetWeek && !_weekTileControllerList[weekIndex].isExpanded) {
          _weekTileControllerList[weekIndex].expand();
        }
      } else if (weekIndex == currentWeekIndex) {
        _weekTileControllerList[weekIndex].expand();
      }

      /* Build weekTile */
      weekTileWidgetList.add(Column(
        children: [
          const Divider(
            height: 3,
            thickness: 3,
          ),
          ExpandedTile(
            key: (weekIndex == currentWeekIndex) ? currenrWeekKey : null,
            onTap: () {
              for (var controller in _weekTileControllerList) {
                if (controller != _weekTileControllerList[weekIndex] && controller.isExpanded) {
                  controller.collapse();
                }
              }
              _articleTileController.collapse();
            },
            controller: _weekTileControllerList[weekIndex],
            theme: ExpandedTileThemeData(
              headerPadding: const EdgeInsets.all(3.0),
              headerColor: Get.theme.secondaryHeaderColor,
              headerRadius: 0.0,
              contentRadius: 0.0,
              contentPadding: const EdgeInsets.all(0.0),
              contentBackgroundColor: Get.theme.scaffoldBackgroundColor,
            ),
            contentSeperator: 0,
            title: Text(weekTitle),
            content: Column(
              children: [
                widget.course.summaryMap[weekTitle] == ''
                    ? const SizedBox.shrink()
                    : Container(
                        child: renderHtml(weekTitle),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Get.theme.hintColor),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        margin: const EdgeInsets.only(bottom: 20.0),
                      ),
                Column(
                  children: activityButtonList,
                ),
              ],
            ),
          ),
        ],
      ));
    }

    return weekTileWidgetList;
  }
}
