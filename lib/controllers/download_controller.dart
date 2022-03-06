import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/permission_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';

enum DownloadQueueingStatus { denied, downloading }

class DownloadController {
  late final Isolate _downloadIsolate;
  late final SendPort _downloadIsolateSendPort;

  final StreamController<List<DownloadInformation>> _streamController = StreamController<List<DownloadInformation>>.broadcast();

  Stream<List<DownloadInformation>> get stream => _streamController.stream;

  DownloadController() {
    ReceivePort receivePort = ReceivePort();
    receivePort.listen((message) {
      if (message["port"] != null) {
        _downloadIsolateSendPort = message["port"];
      } else if (message["message"] != null) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: message["message"]);
      } else {
        _streamController.add(message["data"] as List<DownloadInformation>);
      }
    });

    Isolate.spawn(_isolateBody, receivePort.sendPort).then((isolate) => _downloadIsolate = isolate);
  }

  Future<DownloadQueueingStatus> enQueue(
      {required String url,
      required final String courseTitle,
      required final String courseId,
      required final DownloadType type,
      String title = '',
      final bool force = false}) async {
    assert(type == DownloadType.m3u8 ? title != '' : true);

    final bool permissionRes = await _requestPermission();
    if (permissionRes == false) return DownloadQueueingStatus.denied;

    final String externalDir = (await getExternalStorageDirectory())!.path;
    String saveDir;
    switch (type) {
      case DownloadType.activity:
        saveDir = '$externalDir/$courseTitle\$$courseId';

        final Options options = Options(
          headers: {"Cookie": Get.find<LoginController>().moodleSessionKey},
          followRedirects: false,
          validateStatus: (status) => status == 303 || status == 200,
        );
        var responseTemp = await requestGet(url, options: options, isFront: true);
        if (responseTemp == null) {
          /* TODO: 에러 */

        } else {
          url = responseTemp.headers.value('location')!.split('?')[0];
          title = Uri.decodeFull(url.split('/').last);
        }
        break;
      case DownloadType.normal:
        saveDir = '$externalDir/$courseTitle\$$courseId';
        break;
      case DownloadType.m3u8:
        saveDir = '$externalDir/$courseTitle\$$courseId/$title';
        break;
    }

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

      if (duplicateSelect == false) return DownloadQueueingStatus.denied;
    }

    _downloadIsolateSendPort.send(DownloadInformation(
      url: url,
      courseTitle: courseTitle,
      type: type,
      saveDir: saveDir,
      title: title,
      headers: {"Cookie": Get.find<LoginController>().moodleSessionKey},
      status: DownloadStatus.queueing,
    ));
    return DownloadQueueingStatus.downloading;
  }

  Future<bool> _checkDuplication(final DownloadType type, final String saveDir, final String title) async {
    switch (type) {
      case DownloadType.activity:
      case DownloadType.normal:
        return File('$saveDir/$title').exists();
      case DownloadType.m3u8:
        return File('$saveDir/index.m3u8').exists();
    }
  }

  void _isolateBody(SendPort sendPort) {
    final Queue<DownloadInformation> _pendingQueue = Queue<DownloadInformation>();
    final List<DownloadInformation> _downloadingQueue = <DownloadInformation>[];

    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateQueue(_pendingQueue, _downloadingQueue);
      _sendStatus(sendPort, _pendingQueue, _downloadingQueue);
    });

    final receivePort = ReceivePort();
    sendPort.send({"port": receivePort.sendPort});
    receivePort.listen((downloadInformation) async {
      if (_pendingQueue.length >= 30) {
        sendPort.send({"message": "최대 30개까지 등록할 수 있습니다"});
        return;
      }
      try {
        if (_pendingQueue.any((element) => element.url == downloadInformation.url) ||
            _downloadingQueue.any((element) => element.url == downloadInformation.url)) {
          sendPort.send({"message": "이미 등록된 파일입니다."});
          return;
        }
        sendPort.send({"message": "다운로드 대기열에 추가하였습니다."});
        _pendingQueue.add(downloadInformation);
      } catch (e) {
        /* TODO : 에러 */
        print("[ERROR]$e");
      }
    });
  }

  void _updateQueue(final Queue<DownloadInformation> pendingQueue, final List<DownloadInformation> downloadingQueue) async {
    if (downloadingQueue.length < 3 && pendingQueue.isNotEmpty) {
      var downloadInformation = pendingQueue.first;
      downloadingQueue.add(downloadInformation);
      downloadInformation.status = DownloadStatus.downloading;
      pendingQueue.removeFirst();
      await _runDownloadObject(downloadInformation);

      downloadingQueue.remove(downloadInformation);
    }
  }

  Future<void> _runDownloadObject(final DownloadInformation downloadInformation) async {
    var res = true;
    switch (downloadInformation.type) {
      case DownloadType.m3u8:
        res &= await _downloadM3u8(downloadInformation);
        break;
      default:
        res &= await _downloadNormal(downloadInformation);
        break;
    }

    return;
  }

  Future<bool> _downloadNormal(final DownloadInformation downloadInformation) async {
    final Options options =
        Options(headers: downloadInformation.headers, followRedirects: false, validateStatus: (status) => status == 303 || status == 200);
    try {
      await Directory(downloadInformation.saveDir).create(recursive: true);

      var file = File('${downloadInformation.saveDir}/${downloadInformation.title}');
      if (await file.exists()) {
        await file.delete();
      }

      var res = await Dio().download(
        downloadInformation.url,
        '${downloadInformation.saveDir}/${downloadInformation.title}',
        onReceiveProgress: (count, total) async {
          downloadInformation.current = formatBytes(count, 2);
          downloadInformation.total = "0";
        },
        options: options,
      );
      return true;
    } catch (e) {
      /* TODO : 에러 */
      print("[ERROR]$e");
      return false;
    }
  }

  Future<bool> _downloadM3u8(final DownloadInformation downloadInformation) async {
    try {
      /* variable init */
      final String baseUrl = downloadInformation.url.substring(0, downloadInformation.url.lastIndexOf('/'));
      final List<String> tsUrlList = List.empty(growable: true);
      Map aesConf = {};

      /* get m3u8 body */
      var response = await http.get(Uri.parse(downloadInformation.url));
      var m3u8Str = response.body;

      /* parse m3u8 body */
      m3u8Str.split('\n').forEach((item) {
        if (item.contains('.ts')) {
          tsUrlList.add(baseUrl + '/' + item);
        }
      });

      if (m3u8Str.contains('#EXT-X-KEY')) {
        aesConf = await _getAesConfigure(m3u8Str, baseUrl);
      }

      int index = 0;
      m3u8Str = m3u8Str.split('\n').fold<String>('', (prv, str) {
        if (str.contains('URI=')) {
          var temp = str.split('URI=');
          temp.last = '';
          str = temp.join('URI=') + '"key"';
        }
        if (str.isEmpty || str[0] == '#') {
          return prv + str + '\n';
        } else {
          return prv + '${index++}.ts' + '\n';
        }
      });

      /* download .ts, key, index file */
      bool result = true;
      if (tsUrlList.isNotEmpty) {
        /* delete exist folder */
        var dir = Directory(downloadInformation.saveDir);
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }

        await dir.create(recursive: true);

        /* downlaod .ts */
        result &= await _downloadTs(tsUrlList, downloadInformation);

        /* download key */
        var keyFile = File('${downloadInformation.saveDir}/key');
        keyFile.writeAsBytesSync(aesConf['key']);
        result &= keyFile.lengthSync() == aesConf['key'].length;

        /* download index */
        var indexFile = File('${downloadInformation.saveDir}/index.m3u8');
        indexFile.writeAsStringSync(m3u8Str);
        result &= indexFile.lengthSync() == m3u8Str.length;
      }
      return result;
    } catch (e) {
      /* TODO : 에러 */

      return false;
    }
  }

  Future<Map> _getAesConfigure(final String m3u8Str, final String baseUrl) async {
    Map aesConf = {
      'method': '',
      'uri': '',
      'iv': '',
      'key': '',
    };
    aesConf['method'] = m3u8Str.substring(m3u8Str.indexOf('METHOD=') + 'METHOD='.length, m3u8Str.indexOf(',', m3u8Str.indexOf('METHOD=')));
    aesConf['uri'] = baseUrl + '/' + m3u8Str.substring(m3u8Str.indexOf('URI="') + 'URI="'.length, m3u8Str.indexOf('"', m3u8Str.indexOf('"') + 1));

    aesConf['key'] = Uint8List.fromList((await http.get(Uri.parse(aesConf['uri']))).body.codeUnits);
    return aesConf;
  }

  Future<bool> _downloadTs(final List<String> tsUrlList, final DownloadInformation downloadInformation) async {
    const int junkSize = 10;
    bool res = true;
    for (int i = 0; i < tsUrlList.length; i += junkSize) {
      int retry = 0;
      while (retry < 5) {
        try {
          List<Future> futureList = <Future>[];
          for (int j = i; j < min(tsUrlList.length, i + junkSize); ++j) {
            futureList.add(_downloadOneTs(tsUrlList[j], j, downloadInformation.saveDir));
          }
          var resultList = await Future.wait(futureList);
          for (var r in resultList) {
            res &= r;
          }

          downloadInformation.current = i.toString();
          downloadInformation.total = (tsUrlList.length - 1).toString();
          break;
        } catch (e) {
          ++retry;
        }
      }
      if (retry == 5) {
        throw "${downloadInformation.title}, ${downloadInformation.url}, $i ts download failed";
      }
    }

    return res;
  }

  Future<bool> _downloadOneTs(final String url, final int index, final String saveDir) async {
    var bytes = Uint8List.fromList((await http.get(Uri.parse(url))).body.codeUnits);
    var tsFile = File('$saveDir/$index.ts');
    tsFile.writeAsBytesSync(bytes);
    return tsFile.lengthSync() == bytes.length;
  }

  void _sendStatus(final SendPort sendPort, final Queue<DownloadInformation> pendingQueue, final List<DownloadInformation> downloadingQueue) {
    var data = [...downloadingQueue, ...pendingQueue];
    sendPort.send({
      "data": [...downloadingQueue, ...pendingQueue]
    });
  }

  Future<bool> _requestPermission() {
    return PermissionController.requestPermission();
  }
}
