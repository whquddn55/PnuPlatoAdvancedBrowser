import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/article_page.dart';

class ArticleButton extends StatelessWidget {
  final String courseTitle;
  final String courseId;
  final CourseArticleMetaData article;
  const ArticleButton({Key? key, required this.article, required this.courseTitle, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ArticlePage(metaData: article, courseTitle: courseTitle, courseId: courseId)));
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
}
