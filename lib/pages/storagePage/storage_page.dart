import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/login_builder_page.dart';
import 'package:pnu_plato_advanced_browser/pages/storagePage/directoryPage/directory_page.dart';

class StoragePage extends StatelessWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar("저장소"),
      drawer: const MainDrawer(),
      body: LoginBuilderPage(
        () => FutureBuilder<String>(
          future: StorageController.getDownloadDirectory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return DirectoryPage(rootDirectory: Directory(snapshot.data!));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
