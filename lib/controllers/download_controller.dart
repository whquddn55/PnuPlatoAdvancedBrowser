import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/permission_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/services/background_service.dart';

abstract class DownloadController {
  static Future<void> enQueue(
      {required String url,
      required final String courseTitle,
      required final String courseId,
      required final DownloadType type,
      String title = '',
      final bool force = false}) async {
    assert(type == DownloadType.m3u8 ? title != '' : true);

    if ((await _requestPermission()) == false) return;

    await Fluttertoast.cancel();
    await Fluttertoast.showToast(msg: "다운로드 초기화 작업을 시작 중입니다...");

    List<String>? tempList = await _getUrlAndTitle(type, url, title);
    if (tempList == null || tempList.length != 2) {
      ExceptionController.onExpcetion("response is null on enQueue $type, $url, $title");
      return;
    }
    url = tempList[0];
    title = tempList[1];

    final String saveDir = await _getSaveDir(type, courseTitle, courseId, title);
    bool isExists = await _checkDuplication(type, saveDir, title);
    if (isExists) {
      bool duplicateSelect = await showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            content: const Text("이미 존재하는 파일입니다. 다시 다운로드 받으시겠습니까?"),
            actions: [
              TextButton(
                child: const Text("취소"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(child: const Text("덮어쓰기"), onPressed: () => Navigator.pop(context, true)),
            ],
          );
        },
      );

      if (duplicateSelect == false) return;
    }

    await BackgroundService.sendData(BackgroundServiceAction.download,
        data: {"downloadInformation": DownloadInformation(courseTitle: courseTitle, url: url, type: type, saveDir: saveDir, title: title).toMap()});

    return;
  }

  static Future<String> _getSaveDir(final DownloadType type, final String courseTitle, final String courseId, final String title) async {
    final String externalDir = await StorageController.getDownloadDirectory();
    late final String saveDir;
    switch (type) {
      case DownloadType.activity:
        saveDir = '$externalDir/$courseTitle\$$courseId';
        break;
      case DownloadType.normal:
        saveDir = '$externalDir/$courseTitle\$$courseId';
        break;
      case DownloadType.m3u8:
        saveDir = '$externalDir/$courseTitle\$$courseId/$title';
        break;
    }

    return saveDir;
  }

  static Future<List<String>?> _getUrlAndTitle(final DownloadType type, final String url, final String title) async {
    List<String> res = [url, title];
    switch (type) {
      case DownloadType.activity:
        final Options options = Options(followRedirects: false, validateStatus: (status) => status == 303 || status == 200);
        var responseTemp = await requestGet(url, options: options, isFront: true);
        if (responseTemp == null) return null;
        res[0] = responseTemp.headers.value('location')!.split('?')[0];
        res[1] = Uri.decodeFull(res[0].split('/0/').last);
        break;
      case DownloadType.normal:
      case DownloadType.m3u8:
        break;
    }
    res[1] = res[1].replaceAll('/', '-');

    return res;
  }

  static Future<bool> _requestPermission() {
    return PermissionController.requestPermission();
  }

  static Future<bool> _checkDuplication(final DownloadType type, final String saveDir, final String title) async {
    switch (type) {
      case DownloadType.activity:
      case DownloadType.normal:
        return File('$saveDir/$title').exists();
      case DownloadType.m3u8:
        return File('$saveDir/index.m3u8').exists();
    }
  }
}
