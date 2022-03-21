import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/components/emphasis_container.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/article_page.dart';

class ArticleButton extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final CourseArticleMetaData article;
  final bool isTarget;
  const ArticleButton({Key? key, required this.article, required this.courseTitle, required this.courseId, required this.isTarget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ArticlePage(metaData: article, courseTitle: courseTitle, courseId: courseId)));
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 100,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: NFMarquee(
                    text: article.title,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
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
        ),
        if (isTarget) const Positioned.fill(child: IgnorePointer(child: EmphasisContainer()))
      ],
    );
  }
}
