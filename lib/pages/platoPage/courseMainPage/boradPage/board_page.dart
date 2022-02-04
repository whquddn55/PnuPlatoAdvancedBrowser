import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/course_controller.dart';
import 'package:pnu_plato_advanced_browser/data/course_article.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/platoPage/courseMainPage/articlePage/article_page.dart';

class BoardPage extends StatefulWidget {
  final String boardId;
  const BoardPage({Key? key, required this.boardId}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  int page = 1;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<CourseController>().getBoardInfo(widget.boardId, page),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                        ...(data['articleList'] as List<CourseArticle>).map((CourseArticle article) {
                          return TableRow(
                            children: [
                              TableRowInkWell(
                                onTap: () {
                                  _inkwllTouchEvent(context, article);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          article.title,
                                        ),
                                      ),
                                    ],
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

  void _inkwllTouchEvent(BuildContext context, final CourseArticle article) {
    if (article.id == '') return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlePage(article: article)));
  }
}
