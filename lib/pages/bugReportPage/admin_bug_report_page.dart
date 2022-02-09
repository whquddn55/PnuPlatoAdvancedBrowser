import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/pages/bugReportPage/bug_report_page.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';

class AdminBugReportPage extends StatelessWidget {
  const AdminBugReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("버그리포트 Admin"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("users").orderBy("adminUnread", descending: true).orderBy("time").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage(msg: "채팅내역을 불러오는 중입니다...");
            } else if (snapshot.connectionState != ConnectionState.active) {
              return const LoadingPage(msg: "서버와 연결이 종료되었습니다...");
            } else {
              if (snapshot.data == null) {
                print(snapshot.error);
                return Container();
              }
              var docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  int unread = docs[index]["adminUnread"];
                  return InkWell(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(docs[index].id),
                              Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                                child: Text(
                                  unread.toString(),
                                  style: TextStyle(color: unread == 0 ? null : Colors.red),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BugReportPage(docs[index].id, true)));
                      });
                },
              );
            }
          }),
    );
  }
}
