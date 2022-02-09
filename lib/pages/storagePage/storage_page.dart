import 'dart:io';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
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
        appBar: MainAppbar(
          "저장소",
          bottomWidget: TabBar(
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
