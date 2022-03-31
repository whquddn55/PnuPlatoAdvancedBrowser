import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/firebase_controller.dart';

class NoticePage extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> notice;
  const NoticePage(this.notice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = (notice["time"] as Timestamp).toDate();

    FirebaseController.to.markNoticeRead(notice.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(notice["title"]),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(height: 0, thickness: 1.5, color: Colors.black),
              Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Flexible(
                      child: Center(
                        child: Text(
                          notice['title']!,
                          style: Get.textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Divider(height: 0, thickness: 1, color: Colors.grey[700]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notice['writer']!),
                    Text("${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"),
                  ],
                ),
              ),
              Divider(height: 0, thickness: 1, color: Colors.grey[700]),
              Text(notice["content"].replaceAll('\\n', '\n')),
            ],
          ),
        ),
      ),
    );
  }
}
