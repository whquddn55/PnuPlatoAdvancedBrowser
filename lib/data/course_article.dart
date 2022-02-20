import 'package:pnu_plato_advanced_browser/data/article_comment.dart';

class CourseArticleMetaData {
  final String title;
  final int commentCnt;
  final String writer;
  final String date;
  final String boardId;
  final String id;

  CourseArticleMetaData({
    required this.title,
    this.commentCnt = 0,
    this.writer = '',
    required this.date,
    required this.boardId,
    this.id = '',
  });
}

class CourseArticle {
  final String boardTitle;
  final String title;
  final String writer;
  final String date;
  final String content;
  final List<CourseArticleFile>? fileList;
  final bool commentable;
  final bool editable;
  final bool deletable;
  final ArticleCommentMetaData commentMetaData;
  final List<ArticleComment>? commentList;

  CourseArticle({
    required this.boardTitle,
    required this.title,
    required this.writer,
    required this.date,
    required this.content,
    required this.fileList,
    required this.commentable,
    required this.editable,
    required this.deletable,
    required this.commentMetaData,
    required this.commentList,
  });
}

class CourseArticleFile {
  final String imgUrl;
  final String url;
  final String title;

  CourseArticleFile({
    required this.imgUrl,
    required this.url,
    required this.title,
  });
}
