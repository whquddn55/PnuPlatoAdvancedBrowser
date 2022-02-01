import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/permission_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';

enum DownloadQueueingStatus { denied, permanentlyDenied, downloading }

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
      } else {
        _streamController.add(message["data"] as List<DownloadInformation>);
        //print(message);
      }
    });
    Isolate.spawn(_isolateBody, receivePort.sendPort).then((isolate) => _downloadIsolate = isolate);
  }

  Future<DownloadQueueingStatus> enQueue(
      {required final String url,
      required final String courseTitle,
      required final String courseId,
      required final DownloadType type,
      final String title = '',
      final Map<String, String> headers = const {}}) async {
    assert(type == DownloadType.normal ? headers != const {} : true);
    assert(type == DownloadType.m3u8 ? title != '' : true);

    final PermissionStatus permissionStatus = await _requestPermission();
    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      return DownloadQueueingStatus.permanentlyDenied;
    } else if (permissionStatus != PermissionStatus.granted) {
      return DownloadQueueingStatus.denied;
    } else {
      String externalDir = (await getExternalStorageDirectory())!.path;
      String saveDir = type == DownloadType.normal ? '$externalDir/$courseTitle\$$courseId' : '$externalDir/$courseTitle\$$courseId/$title';
      _downloadIsolateSendPort.send(DownloadInformation(
        url: url,
        courseTitle: courseTitle,
        type: type,
        saveDir: saveDir,
        title: title,
        headers: headers,
        status: DownloadStatus.queueing,
      ));
      return DownloadQueueingStatus.downloading;
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
      try {
        final Options options =
            Options(headers: downloadInformation.headers, followRedirects: false, validateStatus: (status) => status == 303 || status == 200);
        var temp = await Dio().request(downloadInformation.url, options: options);
        downloadInformation.url = temp.headers.value('location')!.split('?')[0];
        downloadInformation.title = Uri.decodeFull(downloadInformation.url.split('/').last);
      } catch (e) {
        /* TODO : 에러 */
        print("[ERROR]$e");
      }
      _pendingQueue.add(downloadInformation);
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
    if (downloadInformation.type == DownloadType.normal) {
      res &= await _downloadNormal(downloadInformation);
    } else {
      res &= await _downloadM3u8(downloadInformation);
    }

    return;
  }

  Future<bool> _downloadNormal(final DownloadInformation downloadInformation) async {
    final Options options =
        Options(headers: downloadInformation.headers, followRedirects: false, validateStatus: (status) => status == 303 || status == 200);
    try {
      Directory(downloadInformation.saveDir).createSync(recursive: true);

      await Dio().download(
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
        Directory(downloadInformation.saveDir).createSync(recursive: true);

        /* download key */
        var keyFile = File('${downloadInformation.saveDir}/key');
        if (keyFile.existsSync()) {
          keyFile.deleteSync();
        }
        keyFile.writeAsBytesSync(aesConf['key']);
        result &= keyFile.lengthSync() == aesConf['key'].length;

        /* download index */
        var indexFile = File('${downloadInformation.saveDir}/index');
        if (indexFile.existsSync()) {
          indexFile.deleteSync();
        }
        indexFile.writeAsStringSync(m3u8Str);
        result &= indexFile.lengthSync() == m3u8Str.length;

        /* downlaod .ts */
        result &= await _downloadTs(tsUrlList, downloadInformation);
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
          final String url = tsUrlList[i];

          List<Future> futureList = <Future>[];
          for (int j = i; j < min(tsUrlList.length, i + junkSize); ++j) {
            futureList.add(_downloadOneTs(url, j, downloadInformation.saveDir));
          }
          var resultList = await Future.wait(futureList);
          for (var r in resultList) {
            res &= r;
          }

          var bytes = Uint8List.fromList((await http.get(Uri.parse(url))).body.codeUnits);
          var tsFile = File('${downloadInformation.saveDir}/$i.ts');
          tsFile.writeAsBytesSync(bytes);
          res &= tsFile.lengthSync() == bytes.length;
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
    sendPort.send({
      "data": [...downloadingQueue, ...pendingQueue]
    });
  }

  Future<PermissionStatus> _requestPermission() {
    return PermissionController.requestPermission();
  }
}
