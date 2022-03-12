import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/article_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/boradPage/boardWritePage/board_write_page.dart';

class BoardPage extends StatefulWidget {
  final String boardId;
  final String courseTitle;
  final String courseId;
  const BoardPage({
    Key? key,
    required this.boardId,
    required this.courseTitle,
    required this.courseId,
  }) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  int page = 1;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CourseController.getBoardInfo(widget.boardId, page),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: Text(data['title']),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    renderHtml(data['content']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_left),
                              padding: EdgeInsets.zero,
                              splashRadius: 16,
                              onPressed: () {
                                setState(() {
                                  page--;
                                  if (page == 0) {
                                    page = 1;
                                  }
                                });
                              },
                            ),
                            Text('$page / ${data['pageLength']}'),
                            IconButton(
                              icon: const Icon(Icons.keyboard_arrow_right),
                              padding: EdgeInsets.zero,
                              splashRadius: 16,
                              onPressed: () {
                                int pg = data['pageLength'];
                                setState(() {
                                  page++;
                                  if (page > pg) {
                                    page = pg;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        data["writable"] == true
                            ? BetaBadge(
                                child: ElevatedButton(
                                  child: const Text("글 쓰기"),
                                  onPressed: () async {
                                    await Navigator.push(context, MaterialPageRoute(builder: (context) => BoardWritePage(widget.boardId)));
                                    setState(() {
                                      page = 1;
                                    });
                                  },
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(7),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(3),
                      },
                      border: TableBorder(
                        top: BorderSide(
                          width: 1,
                          color: Colors.grey[400]!,
                        ),
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey[400]!,
                        ),
                        horizontalInside: BorderSide(
                          width: 1,
                          color: Colors.grey[400]!,
                        ),
                      ),
                      children: [
                        TableRow(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                '제목',
                                textAlign: TextAlign.center,
                              ),
                              color: Colors.grey[200],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                '작성자',
                                textAlign: TextAlign.center,
                              ),
                              color: Colors.grey[200],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                '작성일',
                                textAlign: TextAlign.center,
                              ),
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                        ...(data['articleList'] as List<CourseArticleMetaData>).map((CourseArticleMetaData article) {
                          return TableRow(
                            children: [
                              TableRowInkWell(
                                onTap: () {
                                  _inkwllTouchEvent(context, article);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: article.title, style: const TextStyle(color: Colors.blueAccent)),
                                        const TextSpan(text: "  "),
                                        if (article.commentCnt != 0) TextSpan(text: "[${article.commentCnt.toString()}]"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                onTap: () {
                                  _inkwllTouchEvent(context, article);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                                  child: Text(
                                    article.writer,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                onTap: () {
                                  _inkwllTouchEvent(context, article);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                                  child: Text(
                                    article.date,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList()
                      ],
                    ),
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

  void _inkwllTouchEvent(BuildContext context, final CourseArticleMetaData article) async {
    if (article.id == '') return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlePage(
          metaData: article,
          courseTitle: widget.courseTitle,
          courseId: widget.courseId,
        ),
      ),
    );
    setState(() {});
  }
}
