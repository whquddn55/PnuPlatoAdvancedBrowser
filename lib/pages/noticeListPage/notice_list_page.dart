import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/appbar_wrapper.dart';
import 'package:pnu_plato_advanced_browser/controllers/firebase_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';
import 'package:pnu_plato_advanced_browser/pages/noticeListPage/noticePage/notice_page.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        title: "PPAB 공지사항",
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        future: FirebaseController.to.fetchNoticeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingPage(msg: "공지사항을 불러오는 중입니다...");
          }
          final noticeList = snapshot.data!;
          return GetBuilder<FirebaseController>(builder: (controller) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(7),
                      1: FlexColumnWidth(4),
                      2: FlexColumnWidth(4),
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
                      ...noticeList.map((notice) {
                        var date = (notice["time"] as Timestamp).toDate();
                        bool isNew = controller.noticeMap[notice.id] == false;
                        return TableRow(
                          children: [
                            TableRowInkWell(
                              onTap: () {
                                _inkwllTouchEvent(context, notice);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Badge(
                                        badgeContent: const Text("N"),
                                        showBadge: isNew,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        notice["title"],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TableRowInkWell(
                              onTap: () {
                                _inkwllTouchEvent(context, notice);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                                child: Text(
                                  notice["writer"],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableRowInkWell(
                              onTap: () {
                                _inkwllTouchEvent(context, notice);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                                child: Text(
                                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList()
                    ]),
              ),
            );
          });
        },
      ),
    );
  }

  void _inkwllTouchEvent(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> notice) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => NoticePage(notice)));
  }
}
