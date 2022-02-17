import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/article_comment_controller.dart';
import 'package:pnu_plato_advanced_browser/data/article_comment.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';

abstract class CourseArticleController {
  static List<CourseArticleMetaData> fetchCourseArticleMetaDataList(final Document document, final String boardId) {
    final res = <CourseArticleMetaData>[];
    if (document.getElementsByTagName('tr').length <= 1) {
      return res;
    }
    for (var i = 1; i < document.getElementsByTagName('tr').length; ++i) {
      var tr = document.getElementsByTagName('tr')[i];
      if (tr.children.length < 5) {
        return res;
      }
      var title = tr.children[1].children[0].text.trim();
      var commentCnt = 0;

      if (tr.children[1].getElementsByClassName('comment').isNotEmpty) {
        commentCnt = int.parse(tr.children[1].children[1].text.replaceAll('[', '').replaceAll(']', ''));
      }

      var writer = tr.children[2].text.trim();
      var date = tr.children[3].text.trim();
      String id = '';
      if (tr.children[1].getElementsByTagName('a').isNotEmpty) {
        id = tr.children[1].getElementsByTagName('a')[0].attributes['href']?.split('bwid=')[1] ?? '';
      }
      res.add(CourseArticleMetaData(title: title, commentCnt: commentCnt, date: date, boardId: boardId, id: id, writer: writer));
    }

    return res;
  }

  static Future<CourseArticle?> fetchCourseArticle(final CourseArticleMetaData article) async {
    var response = await requestGet(CommonUrl.courseArticleUrl + 'id=${article.boardId}&bwid=${article.id}', isFront: true);

    if (response == null) {
      /* TODO: 에러 */
      return null;
    }

    Document document = parse(response.data);
    final String boardTitle = document.getElementsByClassName('main')[0].text.trim();
    final String title = document.getElementsByClassName('subject')[0].text.trim();
    final String writer = document.getElementsByClassName('writer')[0].text.trim();
    final String date = document.getElementsByClassName('date')[0].text.trim();
    final String content = document.getElementsByClassName('text_to_html')[0].innerHtml;
    List<CourseArticleFile>? fileList;
    if (document.getElementsByClassName('files').length >= 2) {
      fileList = document.getElementsByClassName('files')[1].children.map((li) {
        var img = li.getElementsByTagName('img')[0];
        var a = li.getElementsByTagName('a')[0];
        return CourseArticleFile(imgUrl: img.attributes['src']!, url: a.attributes['href']!, title: a.text.trim());
      }).toList();
    }
    final bool commentable = document.getElementsByClassName('ubboard_comment').isNotEmpty;
    final ArticleCommentMetaData commentMetaData = ArticleCommentController.getArticleCommentMetaData(document);

    List<ArticleComment>? commentList;
    if (document.getElementsByClassName('comment_list').isNotEmpty) {
      commentList = ArticleCommentController.getArticleCommentList(document);
    }
    return CourseArticle(
      boardTitle: boardTitle,
      title: title,
      writer: writer,
      date: date,
      content: content,
      fileList: fileList,
      commentable: commentable,
      commentMetaData: commentMetaData,
      commentList: commentList,
    );
  }
}
