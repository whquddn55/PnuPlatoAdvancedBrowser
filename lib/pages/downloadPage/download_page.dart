import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/pages/downloadPage/sections/download_card.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: const Text("저장소"), centerTitle: true, actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            Fluttertoast.cancel();
            Fluttertoast.showToast(msg: "플라토 서버의 부하를 줄이기 위해 최대 3개만 동시에 다운로드 할 수 있도록 제한하였습니다.");
          },
        ),
      ]),
      body: StreamBuilder(
        stream: Get.find<DownloadController>().stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<DownloadInformation> list = snapshot.data! as List<DownloadInformation>;
            if (list.isEmpty) {
              return const Center(
                child: Text("다운로드 중인 파일이 없습니다."),
              );
            } else {
              return Column(
                children: list.map((information) {
                  return DownloadCard(downloadInformation: information);
                }).toList(),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
