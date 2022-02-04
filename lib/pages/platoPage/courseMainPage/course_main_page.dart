import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/data/activity.dart';
import 'package:pnu_plato_advanced_browser/data/course.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/article_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/boradPage/board_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/gradePage/grade_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/plannerPage/planner_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/onlineAbsencePage/online_absence_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/smartAbsencePage/smart_absence_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/vodPage/vod_page.dart';

class CourseMainPage extends StatelessWidget {
  final Course course;

  const CourseMainPage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    final _articleTileController = ExpandedTileController();
    final _weekTileControllerList = List<ExpandedTileController>.empty(growable: true);

    return FutureBuilder(
      future: Get.find<CourseController>().updateCourseSpecification(course),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${course.title} - ${course.professor!.name}'),
              centerTitle: true,
              leading: const BackButton(),
            ),
            endDrawer: Drawer(
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
                        children: course.articleList.map((article) {
                          return _articleButton(context, article);
                        }).toList(),
                      ),
                    ),
                  ),
                  ...course.activityMap.keys.map((key) {
                    int index = course.activityMap.keys.toList().indexOf(key);
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
                                  children: course.activityMap[key]!.map((activity) {
                                    return _activityButton(context, activity);
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
          return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: '강의 정보를 로딩 중입니다...'));
        }
      },
    );
  }

  Widget _articleButton(BuildContext context, CourseArticle article) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlePage(article: article)));
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

  Widget _activityButton(BuildContext context, Activity activity) {
    bool avilablity = activity.iconUri != null && activity.availablility == true;
    return InkWell(
      onTap: avilablity == false
          ? null
          : () async {
              if (activity.type == 'ubboard') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BoardPage(boardId: activity.id)));
              } else if (activity.type == 'vod') {
                Get.find<RouteController>().showBottomNavBar = false;
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => _activityBottomSheet(
                    context: context,
                    activity: activity,
                    viewHandler: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => VodPage(id: activity.id)));
                    },
                    downloadHandler: () async {
                      Uri uri = await Get.find<CourseController>().getM3u8Uri(activity.id);
                      if (uri.toString() == '') {
                      } else {
                        var downloadResult = await Get.find<DownloadController>().enQueue(
                          url: uri.toString(),
                          title: activity.title,
                          courseTitle: course.title,
                          courseId: course.id,
                          type: DownloadType.m3u8,
                        );
                        if (downloadResult == DownloadQueueingStatus.denied) {
                          Fluttertoast.showToast(msg: '다운 받기 위해서는 권한이 필요합니다.');
                        } else if (downloadResult == DownloadQueueingStatus.permanentlyDenied) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Text("앱 세팅 화면에서 권한을 모두 허용으로 바꾸어 주세요."),
                              );
                            },
                          );
                          openAppSettings();
                        }
                      }
                    },
                  ),
                );
                Get.find<RouteController>().showBottomNavBar = true;
              } else if (activity.type == 'ubfile') {
                Get.find<RouteController>().showBottomNavBar = false;
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => _activityBottomSheet(
                    context: context,
                    activity: activity,
                    downloadHandler: () async {
                      var downloadResult = await Get.find<DownloadController>().enQueue(
                          url: CommonUrl.fileViewerUrl + activity.id,
                          headers: {"Cookie": Get.find<UserDataController>().moodleSessionKey},
                          courseTitle: course.title,
                          courseId: course.id,
                          type: DownloadType.normal);

                      if (downloadResult == DownloadQueueingStatus.denied) {
                        Fluttertoast.showToast(msg: '다운 받기 위해서는 권한이 필요합니다.');
                      } else if (downloadResult == DownloadQueueingStatus.permanentlyDenied) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: Text("앱 세팅 화면에서 권한을 모두 허용으로 바꾸어 주세요."),
                            );
                          },
                        );
                        openAppSettings();
                      }
                    },
                    viewHandler: () async {
                      var cachedFile = await DefaultCacheManager().getSingleFile(
                        CommonUrl.fileViewerUrl + activity.id,
                        headers: {"Cookie": Get.find<UserDataController>().moodleSessionKey},
                        key: '123',
                      );
                      var result = await OpenFile.open(cachedFile.path);
                      if (result.type != ResultType.done) {
                        Fluttertoast.cancel();
                        Fluttertoast.showToast(msg: result.message);
                      }
                    },
                  ),
                );
                Get.find<RouteController>().showBottomNavBar = true;
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

  Widget _activityBottomSheet({
    required BuildContext context,
    required Activity activity,
    required Function downloadHandler,
    required Function viewHandler,
    Icon downloadIcon = const Icon(Icons.download),
    Icon viewIcon = const Icon(Icons.open_in_new),
    String downloadText = "다운로드",
    String viewText = "열기",
  }) {
    return Container(
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
              FutureBuilder(
                future: Get.find<CourseController>().getVodStatus(activity.courseId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data as Map<String, bool>;
                    Widget status;
                    if (data.containsKey(activity.title)) {
                      if (data[activity.title] == true) {
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
                      return Row(
                        children: [
                          const Text('출석 상태: '),
                          status,
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  } else {
                    return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator());
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
                icon: downloadIcon,
                label: Text(downloadText),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () => downloadHandler(),
              ),
              TextButton.icon(
                icon: viewIcon,
                label: Text(viewText),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  primary: Get.textTheme.bodyText1!.color,
                ),
                onPressed: () => viewHandler(),
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
