import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/notification_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';

abstract class BackgroundDownloadController {
  static Map<int, CancelToken> tokenMap = {};
  static Future<void> download(final DownloadInformation downloadInformation) async {
    final bool downloading = tokenMap[downloadInformation.url.hashCode] != null;

    if (downloading == true) {
      await Fluttertoast.cancel();
      await Fluttertoast.showToast(msg: "이미 다운로드 중입니다.");
    } else {
      await Fluttertoast.cancel();
      await Fluttertoast.showToast(msg: "다운로드를 시작합니다.");
      switch (downloadInformation.type) {
        case DownloadType.m3u8:
          await _downloadM3u8(downloadInformation);
          break;
        default:
          await _downloadNormal(downloadInformation);
          break;
      }
    }
    return;
  }

  static CancelToken _registerCancelToken(final int id) {
    final CancelToken cancelToken = CancelToken();
    tokenMap[id] = cancelToken;
    return cancelToken;
  }

  static Future<bool> _downloadNormal(final DownloadInformation downloadInformation) async {
    final Options options = Options(headers: {"Cookie": BackgroundLoginController.loginInformation.moodleSessionKey});
    final int id = downloadInformation.url.hashCode;

    try {
      await Directory(downloadInformation.saveDir).create(recursive: true);

      var file = File('${downloadInformation.saveDir}/${downloadInformation.title}');
      if (await file.exists()) {
        await file.delete();
      }

      final CancelToken cancelToken = _registerCancelToken(id);

      await _showProgressNotification(id, downloadInformation.title);
      await Dio().download(
        downloadInformation.url,
        '${downloadInformation.saveDir}/${downloadInformation.title}',
        options: options,
        cancelToken: cancelToken,
      );

      await _showCompleteNotification(id, downloadInformation.title);

      tokenMap.remove(id);

      return true;
    } on DioError catch (e, stacktrace) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.response:
        case DioErrorType.other:
          await _showFailNotification(id, downloadInformation.title, body: e.message);
          var file = File('${downloadInformation.saveDir}/${downloadInformation.title}');
          if (await file.exists()) await file.delete();
          if (e.type != DioErrorType.other) {
            await ExceptionController.onExpcetion(stacktrace.toString(), false);
          }
          break;
        case DioErrorType.cancel:
          break;
      }

      tokenMap.remove(id);
      return false;
    } on FileSystemException catch (e) {
      await _showFailNotification(id, downloadInformation.title, body: e.message);
      var file = File('${downloadInformation.saveDir}/${downloadInformation.title}');
      if (await file.exists()) await file.delete();

      tokenMap.remove(id);
      return false;
    }
  }

  static Future<void> _showProgressNotification(final int id, final String title, {int? progress}) async {
    await NotificationController.showNotification(NotificationType.progress, id, title, "다운로드중...", {}, progress: progress);
  }

  static Future<void> _showCompleteNotification(final int id, final String title) async {
    await NotificationController.showNotification(NotificationType.result, id, title, "다운로드 완료!", {});
  }

  static Future<void> _showFailNotification(final int id, final String title, {final String body = ""}) async {
    await NotificationController.showNotification(NotificationType.result, id, title, "다운로드 실패..." + body, {});
  }

  static Future<bool> _downloadM3u8(final DownloadInformation downloadInformation) async {
    final int id = downloadInformation.url.hashCode;
    try {
      /* variable init */
      final String baseUrl = downloadInformation.url.substring(0, downloadInformation.url.lastIndexOf('/'));
      var response = await http.get(Uri.parse(downloadInformation.url));
      String m3u8Str = response.body;

      final List<String> tsUrlList = _getTsUrlList(m3u8Str, baseUrl);
      final Map<String, dynamic> aesConf = await _getAesConfigure(m3u8Str, baseUrl);
      m3u8Str = _reconstructM3u8Str(m3u8Str);

      /* download .ts, key, index file */

      bool res = true;
      if (tsUrlList.isNotEmpty) {
        /* delete exist folder */
        var dir = Directory(downloadInformation.saveDir);
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }

        await dir.create(recursive: true);

        /* downlaod .ts */
        final CancelToken cancelToken = _registerCancelToken(id);
        res &= await _downloadTs(tsUrlList, downloadInformation, cancelToken);

        if (cancelToken.isCancelled) throw DioError(requestOptions: RequestOptions(path: ''), type: DioErrorType.cancel);

        /* download key */
        var keyFile = File('${downloadInformation.saveDir}/key');
        await keyFile.writeAsBytes(aesConf['key']);
        res &= (await keyFile.length()) == aesConf['key'].length;

        /* download index */
        var indexFile = File('${downloadInformation.saveDir}/index.m3u8');
        await indexFile.writeAsString(m3u8Str);
        res &= await (indexFile.length()) == m3u8Str.length;

        await _showCompleteNotification(id, downloadInformation.title);

        tokenMap.remove(id);
      }
      return res;
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.response:
        case DioErrorType.other:
          await _showFailNotification(id, downloadInformation.title, body: e.message);
          break;
        case DioErrorType.cancel:
          NotificationController.dismissNotification(id);
          break;
      }
      var dir = Directory(downloadInformation.saveDir);
      if (await dir.exists()) await dir.delete(recursive: true);

      tokenMap.remove(id);
      return false;
    } on Exception catch (e) {
      await _showFailNotification(id, downloadInformation.title, body: e.toString());
      var dir = Directory(downloadInformation.saveDir);
      if (await dir.exists()) await dir.delete(recursive: true);

      tokenMap.remove(id);
      return false;
    }
  }

  static Future<bool> _downloadTs(final List<String> tsUrlList, final DownloadInformation downloadInformation, final CancelToken cancelToken) async {
    final int id = downloadInformation.url.hashCode;
    const int junkSize = 10;
    bool res = true;
    for (int i = 0; i < tsUrlList.length; i += junkSize) {
      int retry = 0;
      while (retry < 5) {
        try {
          List<Future> futureList = <Future>[];
          for (int j = i; j < min(tsUrlList.length, i + junkSize); ++j) {
            if (cancelToken.isCancelled) throw DioError(requestOptions: RequestOptions(path: ''), type: DioErrorType.cancel);
            futureList.add(_downloadOneTs(tsUrlList[j], j, downloadInformation.saveDir, cancelToken));
          }

          var resultList = await Future.wait(futureList);
          for (var r in resultList) {
            res &= r;
          }

          final int progress = (((i + junkSize) / tsUrlList.length) * 100).toInt();
          await _showProgressNotification(id, downloadInformation.title, progress: progress);
          break;
        } on HttpException catch (_) {
          ++retry;
        }
      }
      if (retry == 5) {
        throw Exception("OverTried : 5times over");
      }
    }

    return res;
  }

  static Future<bool> _downloadOneTs(final String url, final int index, final String saveDir, final CancelToken cancelToken) async {
    try {
      var bytes = Uint8List.fromList((await http.get(Uri.parse(url))).body.codeUnits);
      if (cancelToken.isCancelled) throw DioError(requestOptions: RequestOptions(path: ''), type: DioErrorType.cancel);
      var tsFile = File('$saveDir/$index.ts');
      tsFile.writeAsBytesSync(bytes);
      return tsFile.lengthSync() == bytes.length;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> _getAesConfigure(final String m3u8Str, final String baseUrl) async {
    if (m3u8Str.contains('#EXT-X-KEY') == false) return {};
    var aesConf = <String, dynamic>{
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

  static List<String> _getTsUrlList(final String m3u8Str, final String baseUrl) {
    final tsUrlList = <String>[];
    m3u8Str.split('\n').forEach((item) {
      if (item.contains('.ts')) {
        tsUrlList.add(baseUrl + '/' + item);
      }
    });
    return tsUrlList;
  }

  static String _reconstructM3u8Str(String m3u8Str) {
    int index = 0;
    return m3u8Str.split('\n').fold<String>('', (prv, str) {
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
  }
}
