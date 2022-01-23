import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/courseController.dart';
import 'package:pnu_plato_advanced_browser/data/courseArticle.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';

class ArticlePage extends StatelessWidget {
  final CourseArticle article;

  ArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<CourseController>().getArticleInfo(article),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, String> data = snapshot.data as Map<String, String>;
          return Scaffold(
            appBar: AppBar(
              title: Text(data['main']!),
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
                                data['title']!,
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
                          Text(data['writer']!),
                          Text(data['date']!),
                        ],
                      ),
                    ),
                    Divider(height: 0, thickness: 1, color: Colors.grey[700]),
                    renderHtml(data['content']!),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const LoadingPage(msg: '로딩중 ...');
        }
      },
    );
  }
}
