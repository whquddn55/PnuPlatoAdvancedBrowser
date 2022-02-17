import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_article_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/sections/article_comment_list_widget.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/sections/article_file_list_widget.dart';

class ArticlePage extends StatelessWidget {
  final CourseArticleMetaData article;
  final String courseTitle;
  final String courseId;

  const ArticlePage({
    Key? key,
    required this.article,
    required this.courseTitle,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CourseArticleController.fetchCourseArticle(article),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          CourseArticle data = snapshot.data as CourseArticle;
          return Scaffold(
            appBar: AppBar(
              title: Text(data.boardTitle),
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
                                data.title,
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
                          Text(data.writer),
                          Text(data.date),
                        ],
                      ),
                    ),
                    if (data.fileList != null) ArticleFileListWidget(data.fileList!, courseTitle, courseId),
                    Divider(height: 0, thickness: 1, color: Colors.grey[700]),
                    renderHtml(data.content),
                    if (data.commentable) ArticleCommentListWidget(data.commentMetaData, data.commentList),
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
}
