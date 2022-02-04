import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/storagePage/downloadPage/sections/download_card.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Get.find<DownloadController>().stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<DownloadInformation> list = snapshot.data! as List<DownloadInformation>;
          if (list.isEmpty) {
            return const Center(
              child: Text("다운로드 중인 파일이 없습니다."),
            );
          } else {
            return ListView(
              children: list.map((information) {
                return DownloadCard(downloadInformation: information);
              }).toList(),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
