import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/storagePage/directoryPage/directory_page.dart';
import 'package:pnu_plato_advanced_browser/pages/storagePage/downloadPage/download_page.dart';

class StoragePage extends StatelessWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text("저장소"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                Fluttertoast.cancel();
                Fluttertoast.showToast(msg: "플라토 서버의 부하를 줄이기 위해 최대 3개만 동시에 다운로드 할 수 있도록 제한하였습니다.");
              },
            ),
          ],
          leading: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            //Get.find<UserDataController>().studentId.toString()
            stream: FirebaseFirestore.instance.collection("chats").doc("1234").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer());
              }

              int unread = snapshot.data!["unread"];
              return IconButton(
                icon: Badge(
                  child: const Icon(Icons.menu),
                  badgeContent: Text(unread.toString()),
                  showBadge: unread != 0,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          bottom: TabBar(
            tabs: [
              const Tab(icon: Icon(Icons.folder)),
              StreamBuilder<List<DownloadInformation>>(
                  stream: Get.find<DownloadController>().stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      List<DownloadInformation> list = snapshot.data!;
                      return Tab(
                        icon: Badge(
                          badgeContent: Text(list.length.toString()),
                          child: const Icon(Icons.download),
                          showBadge: list.isNotEmpty,
                        ),
                      );
                    } else {
                      return const Tab(icon: Icon(Icons.download_rounded));
                    }
                  }),
            ],
          ),
        ),
        drawer: const MainDrawer(),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            FutureBuilder(
                future: getExternalStorageDirectory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return DirectoryPage(rootDirectory: snapshot.data! as Directory);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            const DownloadPage()
          ],
        ),
      ),
    );
  }
}
