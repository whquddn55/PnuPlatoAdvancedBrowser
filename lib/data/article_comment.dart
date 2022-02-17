class ArticleCommentMetaData {
  final String id;
  final String cid;
  final String bid;
  final String bwid;

  ArticleCommentMetaData({
    required this.id,
    required this.cid,
    required this.bid,
    required this.bwid,
  });
}

class ArticleComment {
  final String commentId;
  final String writerId;
  final String imgUrl;
  final String writerName;
  final String date;
  final String contents;
  final int depth;
  final bool repliable;
  final bool editable;
  final bool erasable;

  ArticleComment({
    required this.commentId,
    required this.writerId,
    required this.imgUrl,
    required this.writerName,
    required this.date,
    required this.contents,
    required this.depth,
    required this.repliable,
    required this.editable,
    required this.erasable,
  });
}
