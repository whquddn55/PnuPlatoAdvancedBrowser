import 'package:flutter/cupertino.dart';

enum DownloadType { activity, m3u8, normal }

class DownloadInformation {
  final String courseTitle;
  final DownloadType type;
  final String saveDir;
  String url;
  String title;

  DownloadInformation({
    required this.url,
    required this.courseTitle,
    required this.type,
    required this.saveDir,
    this.title = '',
  }) {
    assert(type == DownloadType.m3u8 ? title != '' : true);
  }

  DownloadInformation.fromJson(final Map<String, String> json)
      : courseTitle = json["courseTitle"]!,
        saveDir = json["saveDir"]!,
        type = DownloadType.values.byName(json["type"]!),
        url = json["url"]!,
        title = json["title"]!;

  Map<String, String> toMap() {
    return {
      "courseTitle": courseTitle,
      "type": type.name,
      "saveDir": saveDir,
      "url": url,
      "title": title,
    };
  }
}
