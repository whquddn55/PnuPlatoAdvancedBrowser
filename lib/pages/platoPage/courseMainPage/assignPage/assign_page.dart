import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:intl/intl.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_assign_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_assign.dart';
import 'package:pnu_plato_advanced_browser/data/course_file.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/inappwebview_wrapper.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/sections/file_bottom_sheet.dart';

class AssignPage extends StatefulWidget {
  final String assignId;
  final String courseTitle;
  final String courseId;
  const AssignPage({Key? key, required this.assignId, required this.courseTitle, required this.courseId}) : super(key: key);

  @override
  State<AssignPage> createState() => _AssignPageState();
}

class _AssignPageState extends State<AssignPage> {
  List<Node> _buildFileListWidget(final BuildContext context, final List<dynamic> fileList) {
    List<Node> res = [];
    for (var element in fileList) {
      if (element.runtimeType == CourseFile) {
        res.add(Node(key: jsonEncode(element), label: '1', data: element));
      } else {
        var children = _buildFileListWidget(context, element["folder"]);
        res.add(Node(key: "", label: '2', data: element, children: children));
      }
    }
    return res;
  }

  Widget _renderFileList(final BuildContext context, final List<dynamic> fileList, final String metaString, CrossAxisAlignment alignment) {
    if (fileList.isEmpty) return const SizedBox.shrink();

    TreeViewController controller = TreeViewController(children: _buildFileListWidget(context, fileList));

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(metaString, style: const TextStyle(color: Colors.grey)),
        TreeView(
          controller: controller,
          shrinkWrap: true,
          primary: false,
          theme: const TreeViewTheme(expanderTheme: ExpanderThemeData(type: ExpanderType.none)),
          onNodeTap: (key) {
            CourseFile courseFile = CourseFile.fromJson(jsonDecode(key));
            showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                builder: (context) =>
                    FileBottomSheet(file: courseFile, fileType: DownloadType.normal, courseTitle: widget.courseTitle, courseId: widget.courseId));
          },
          nodeBuilder: (context, node) {
            if (node.data.runtimeType == CourseFile) {
              CourseFile courseFile = node.data;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [CachedNetworkImage(imageUrl: courseFile.imgUrl), const SizedBox(width: 4.0), Text(courseFile.title)],
                ),
              );
            } else {
              return Row(
                children: [CachedNetworkImage(imageUrl: node.data["imgUrl"]), const SizedBox(width: 4.0), Text(node.data["title"])],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _renderSubmissionStatus(final CourseAssign courseAssign) {
    Color dueStringColor;
    switch (courseAssign.dueType) {
      case CourseAssignDueType.late:
      case CourseAssignDueType.over:
        dueStringColor = Colors.redAccent;
        break;
      case CourseAssignDueType.early:
        dueStringColor = Colors.green;
        break;
      default:
        dueStringColor = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (courseAssign.dueDate != null) Text("종료 일시: ${DateFormat("yyyy-MM-dd hh:mm").format(courseAssign.dueDate!)}"),
          if (courseAssign.dueString != null)
            Text(courseAssign.dueString! + (courseAssign.dueType == null ? " 남았습니다." : ""), style: TextStyle(color: dueStringColor)),
        ],
      ),
    );
  }

  Widget _renderSubmitForm(final BuildContext context, final CourseAssign courseAssign) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderFileList(context, courseAssign.attatchFileList, "제출한 파일", CrossAxisAlignment.start),
        if (courseAssign.isUpadtedToOver)
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.pink),
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xfff8d7da),
            ),
            child: const Text("지금 과제물을 편집하면 제출 상태가 변경됩니다.\n(정상제출 => 늦은제출)"),
          ),
        if (courseAssign.lastEditDate != null) Text("최종 수정 일시: ${DateFormat("yyyy-MM-dd hh:mm").format(courseAssign.lastEditDate!)}"),
        if (courseAssign.submitable)
          BetaBadge(
            child: OutlinedButton(
              child: Text(courseAssign.submitted == true ? "편집하기" : "제출하기"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InappwebviewWrapper(
                      "과제 제출",
                      CommonUrl.courseAssignViewUrl + widget.assignId + "&action=editsubmission",
                      (controller, uri) async {
                        await controller.evaluateJavascript(
                            source: '''document.body.replaceChild(document.getElementById('mform1'), document.getElementById('page')); 
                               document.getElementById('fitem_id_files_filemanager').style['margin-left'] = '0px';
                               while (document.getElementsByClassName('col-md-3 col-form-label d-flex justify-content-md-end').length) document.getElementsByClassName('col-md-3 col-form-label d-flex justify-content-md-end')[0].remove();
                               document.body.style.margin = '0px';
                                document.body.style.padding = '0px';''');
                      },
                      preventRedirect: true,
                    ),
                  ),
                );

                setState(() {});
              },
            ),
          ),
      ],
    );
  }

  Widget _renderGradeResult(final CourseAssign courseAssign) {
    if (courseAssign.graded == false) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          icon: CachedNetworkImage(imageUrl: courseAssign.gradeResult!.grader.iconUri.toString()),
          label: Text(courseAssign.gradeResult!.grader.name),
          onPressed: () {},
        ),
        Text("성적: ${courseAssign.gradeResult!.grade}"),
        Text("채첨일시: ${DateFormat("yyyy-MM-dd hh:mm").format(courseAssign.gradeResult!.gradeTime)}"),
        Container(
          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(4.0)),
          padding: const EdgeInsets.all(4.0),
          child: courseAssign.gradeResult!.feedback ?? const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CourseAssign?>(
      future: CourseAssignController.fetchCourseAssign(widget.assignId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: LoadingPage(msg: "로딩 중입니다..."));
        } else {
          if (snapshot.data == null) {
            return const ErrorPage(msg: "과제 정보를 가져오는데 문제가 발생했습니다...");
          } else {
            final courseAssign = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text(courseAssign.title),
                centerTitle: true,
                actions: [
                  Row(
                    children: [
                      const Text("제출 상황:"),
                      courseAssign.submitted != false ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.close, color: Colors.red),
                    ],
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _renderSubmissionStatus(courseAssign),
                      const Divider(thickness: 1.0, height: 4.0),
                      _renderFileList(context, courseAssign.fileList, "첨부파일", CrossAxisAlignment.start),
                      const Divider(thickness: 1.0, height: 4.0),
                      courseAssign.content,
                      const Divider(thickness: 1.0, height: 4.0),
                      const SizedBox(height: 20),
                      courseAssign.team != null
                          ? Text(courseAssign.team!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                          : const SizedBox.shrink(),
                      _renderSubmitForm(context, courseAssign),
                      const Divider(thickness: 1.0, height: 4.0),
                      const SizedBox(height: 40),
                      _renderGradeResult(courseAssign),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
