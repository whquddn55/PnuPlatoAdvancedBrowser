import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("다운로드"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Get.find<DownloadController>().stream,
        builder: (context, data) {
          return Text('1');
        },
      ),
    );
  }
}
