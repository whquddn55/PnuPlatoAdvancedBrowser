import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/article_comment.dart';

abstract class ArticleCommentController {
  static ArticleCommentMetaData getArticleCommentMetaData(final Document document) {
    String id = '', cid = '', bid = '', bwid = '';
    for (var element in document.getElementsByClassName('controls')[0].children) {
      if (element.attributes['name'] == 'id') {
        id = element.attributes['value'] ?? '';
      } else if (element.attributes['name'] == 'cid') {
        cid = element.attributes['value'] ?? '';
      } else if (element.attributes['name'] == 'bid') {
        bid = element.attributes['value'] ?? '';
      } else if (element.attributes['name'] == 'bwid') {
        bwid = element.attributes['value'] ?? '';
      }
    }
    return ArticleCommentMetaData(id: id, cid: cid, bid: bid, bwid: bwid);
  }

  static List<ArticleComment> getArticleCommentList(final Document document) {
    final List<ArticleComment> articleCommentList = <ArticleComment>[];
    for (var element in document.getElementsByClassName('comment_list')) {
      articleCommentList.add(ArticleComment(
        commentId: element.getElementsByClassName('btn btn-xs btn-default')[0].attributes['href']!.replaceAll('#', ''),
        writerId: element.getElementsByTagName('a')[0].attributes["href"]!.split("?id=")[1].split("&")[0],
        imgUrl: element.getElementsByTagName('img')[0].attributes['src']!,
        writerName: element.getElementsByClassName('media-body')[0].children[0].text.trim(),
        date: element.getElementsByClassName('media-body')[0].children[1].text.trim(),
        contents: element.getElementsByClassName('media-body')[0].children[3].text.trim(),
        depth: int.parse(element.attributes["style"]?.split("px")[0].split(":")[1] ?? '0') ~/ 25,
        repliable: element.getElementsByClassName('comment_reply').isNotEmpty,
        editable: element.getElementsByClassName('comment_modify').isNotEmpty,
        erasable: element.getElementsByClassName('comment_delete').isNotEmpty,
      ));
    }

    return articleCommentList;
  }

  static Future<List<ArticleComment>?> writeComment(final String? targetId, final ArticleCommentMetaData metaData, final String content) async {
    if (content.trim().isEmpty) {
      return null;
    }
    final Options options = Options(validateStatus: (status) => status == 303 || status == 200, contentType: Headers.formUrlEncodedContentType);
    var res = await requestPost(
      CommonUrl.courseBoardActionUrl,
      {
        "comment": content,
        "id": metaData.id,
        "bid": metaData.bid,
        "cid": metaData.cid,
        "bwid": metaData.bwid,
        "type": targetId == null ? "comment_write" : "comment_reply",
        "bcid": targetId ?? '',
      },
      options: options,
      isFront: true,
      retry: 1,
    );

    if (res == null) return null;
    return getArticleCommentList(Document.html(res.data));
  }

  static Future<List<ArticleComment>?> deleteComment(final String targetId, final ArticleCommentMetaData metaData) async {
    final Options options = Options(validateStatus: (status) => status == 303 || status == 200, contentType: Headers.formUrlEncodedContentType);
    var res = await requestPost(
      CommonUrl.courseBoardActionUrl,
      {
        "id": metaData.id,
        "bid": metaData.bid,
        "cid": metaData.cid,
        "bwid": metaData.bwid,
        "type": "comment_delete",
        "bcid": targetId,
      },
      options: options,
      isFront: true,
    );
    if (res == null) return null;
    return getArticleCommentList(Document.html(res.data));
  }
}
