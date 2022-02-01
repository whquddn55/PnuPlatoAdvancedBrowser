enum DownloadType { normal, m3u8 }
enum DownloadStatus { queueing, downloading, complete, fail }

class DownloadInformation {
  final String url;
  final String courseTitle;
  final DownloadType type;
  final String title;
  final String saveDir;
  final Map<String, String> headers;
  String current = '';
  String total = '';
  DownloadStatus status;

  DownloadInformation({
    required this.url,
    required this.courseTitle,
    required this.type,
    required this.saveDir,
    this.title = '',
    this.headers = const {},
    this.total = '',
    this.status = DownloadStatus.queueing,
  }) {
    assert(type == DownloadType.normal ? headers != {} : true);
    assert(type == DownloadType.m3u8 ? title != '' : true);
  }
}
