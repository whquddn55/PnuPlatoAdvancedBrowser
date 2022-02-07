import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';

class BugReportChatting extends StatelessWidget {
  final String studentId;
  final bool isAdmin;
  const BugReportChatting(this.studentId, this.isAdmin, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDoc = FirebaseFirestore.instance.collection('chats').doc(studentId);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('chats').doc(studentId).collection('messages').orderBy("time", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage(msg: "채팅내역을 불러오는 중입니다...");
          } else if (snapshot.connectionState != ConnectionState.active) {
            return const LoadingPage(msg: "서버와 연결이 종료되었습니다...");
          } else {
            final docs = snapshot.data!.docs;
            if (isAdmin) {
              userDoc.update({"adminUnread": 0});
            } else {
              userDoc.update({"unread": 0});
            }
            return ListView.builder(
                reverse: true,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  bool isUser = isAdmin ^ docs[index]["isUser"];
                  return Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
                              bottomRight: isUser ? Radius.zero : const Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          margin: isUser
                              ? const EdgeInsets.only(left: 50.0, top: 4.0, bottom: 4.0, right: 4.0)
                              : const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0, right: 50.0),
                          child: Text(
                            docs[index]["text"],
                            style: TextStyle(color: isUser ? Colors.white : Colors.black),
                          ),
                        ),
                      )
                    ],
                  );
                });
          }
        });
  }
}
