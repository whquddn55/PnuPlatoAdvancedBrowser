import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';
import 'package:pnu_plato_advanced_browser/services/background_service_controllers/background_login_controller.dart';

abstract class BackgroundDownloadController {
  static Future<void> download(final DownloadInformation downloadInformation) async {
    var res = true;
    switch (downloadInformation.type) {
      case DownloadType.m3u8:
        res &= await _M3u8Downloader.downloadM3u8(downloadInformation);
        break;
      default:
        res &= await _downloadNormal(downloadInformation);
        break;
    }

    return;
  }

  static Future<bool> _downloadNormal(final DownloadInformation downloadInformation) async {
    final Options options = Options(headers: {"Cookie": BackgroundLoginController.loginInformation.moodleSessionKey});
    try {
      await Directory(downloadInformation.saveDir).create(recursive: true);

      var file = File('${downloadInformation.saveDir}/${downloadInformation.title}');
      if (await file.exists()) {
        await file.delete();
      }

      final CancelToken cancelToken = CancelToken();
      var res = await Dio().download(
        downloadInformation.url,
        '${downloadInformation.saveDir}/${downloadInformation.title}',
        onReceiveProgress: (count, total) async {
          await _showNotification(downloadInformation.hashCode, downloadInformation.title, cancelToken);
        },
        options: options,
        cancelToken: cancelToken,
        deleteOnError: true,
      );
      return true;
    } catch (e) {
      /* TODO : 에러 */
      printLog("[ERROR]$e");
      return false;
    }
  }

  static Future<void> _showNotification(final int id, final String title, final CancelToken cancelToken) async {
    /* TODO: Register cancelToken */
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        groupKey: 'ppab_noti_group',
        channelKey: 'ppab_noti_download_status',
        title: title,
        body: '다운로드중...',
        autoDismissible: false,
        displayOnForeground: true,
        displayOnBackground: true,
        locked: true,
        notificationLayout: NotificationLayout.ProgressBar,
      ),
      actionButtons: [NotificationActionButton(key: "cancel", label: "취소", buttonType: ActionButtonType.DisabledAction)],
    );
  }
}

abstract class _M3u8Downloader {
  static Future<bool> downloadM3u8(final DownloadInformation downloadInformation) async {
    try {
      /* variable init */
      final String baseUrl = downloadInformation.url.substring(0, downloadInformation.url.lastIndexOf('/'));
      var response = await http.get(Uri.parse(downloadInformation.url));
      String m3u8Str = response.body;

      final List<String> tsUrlList = _getTsUrlList(m3u8Str, baseUrl);
      final Map<String, dynamic> aesConf = await _getAesConfigure(m3u8Str, baseUrl);
      m3u8Str = _reconstructM3u8Str(m3u8Str);

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

  static Future<bool> _downloadTs(final List<String> tsUrlList, final DownloadInformation downloadInformation) async {
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

          await _showNotification(downloadInformation.hashCode, downloadInformation.title);
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

  static Future<bool> _downloadOneTs(final String url, final int index, final String saveDir) async {
    var bytes = Uint8List.fromList((await http.get(Uri.parse(url))).body.codeUnits);
    var tsFile = File('$saveDir/$index.ts');
    tsFile.writeAsBytesSync(bytes);
    return tsFile.lengthSync() == bytes.length;
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

  static Future<void> _showNotification(final int id, final String title) async {
    /* TODO: 취소기능 추가 */
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'ppab_noti_download_status',
        title: title,
        body: '다운로드중...',
        autoDismissible: false,
        displayOnForeground: true,
        displayOnBackground: true,
        locked: true,
        notificationLayout: NotificationLayout.ProgressBar,
      ),
      actionButtons: [NotificationActionButton(key: "cancel", label: "취소")],
    );
  }
}
