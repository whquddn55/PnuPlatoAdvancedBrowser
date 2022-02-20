import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/inappwebview_wrapper.dart';

class ArticleEditPage extends StatelessWidget {
  final String boardId;
  final String articleId;
  const ArticleEditPage(this.boardId, this.articleId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InappwebviewWrapper(
      '글쓰기',
      CommonUrl.courseBoardWriteUrl + boardId + "&bwid=" + articleId,
      (controller, url) async => await controller.evaluateJavascript(
        source:
            "document.getElementById('page-header').remove();document.getElementsByClassName('page-content-navigation')[0].remove(); document.getElementById('id_cancel').remove();",
      ),
    );
  }
}
