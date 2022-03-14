import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller/course_article_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/pages/error_page.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/sections/article_comment_list.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/sections/article_edit_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/sections/article_file_list.dart';

class ArticlePage extends StatefulWidget {
  final CourseArticleMetaData metaData;
  final String courseTitle;
  final String courseId;

  const ArticlePage({
    Key? key,
    required this.metaData,
    required this.courseTitle,
    required this.courseId,
  }) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CourseArticleController.fetchCourseArticle(widget.metaData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const ErrorPage(msg: "교수님이 게시글을 삭제하신거 같아요...");
          }
          CourseArticle article = snapshot.data as CourseArticle;
          return Scaffold(
            appBar: AppBar(
              title: Text(article.boardTitle),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(height: 0, thickness: 1.5, color: Colors.black),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Flexible(
                            child: Center(
                              child: Text(
                                article.title,
                                style: Get.textTheme.subtitle1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Divider(height: 0, thickness: 1, color: Colors.grey[700]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(article.writer),
                          Text(article.date),
                        ],
                      ),
                    ),
                    if (article.fileList != null) ArticleFileList(article.fileList!, widget.courseTitle, widget.courseId),
                    Divider(height: 0, thickness: 1, color: Colors.grey[700]),
                    renderHtml(article.content),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (article.editable)
                          BetaBadge(
                            child: ElevatedButton(
                              child: const Text("수정"),
                              onPressed: () async {
                                await Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => ArticleEditPage(widget.metaData.boardId, widget.metaData.id)));
                                setState(() {});
                              },
                            ),
                          ),
                        const SizedBox(width: 10),
                        if (article.deletable)
                          ElevatedButton(
                            child: const Text("삭제"),
                            style: ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              _deleteArticle(context);
                            },
                          ),
                      ],
                    ),
                    if (article.commentable) ArticleCommentList(article.commentMetaData, article.commentList),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(appBar: AppBar(), body: const LoadingPage(msg: '로딩중 ...'));
        }
      },
    );
  }

  Future<void> _deleteArticle(final BuildContext context) async {
    var dialogRes = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("게시글을 삭제합니다."),
          actions: [
            TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context, false)),
            TextButton(child: const Text("삭제"), onPressed: () => Navigator.pop(context, true)),
          ],
        );
      },
    );

    if (dialogRes) {
      CourseArticleController.deleteCourseArticle(widget.metaData);
    }
  }
}
