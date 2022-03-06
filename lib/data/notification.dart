enum NotificationType { ubboard, ubfile, zoom, vod, folder, url }

class Notification {
  final String title;
  final String body;
  final String url;
  final DateTime time;
  final NotificationType notificationType;

  Notification({required this.title, required this.body, required this.url, required this.time, required this.notificationType});

  Notification.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        body = json["body"],
        url = json["url"],
        time = DateTime.parse(json["time"]),
        notificationType = NotificationType.values.byName(json["notificationType"]);

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "url": url,
      "time": time.toString(),
      "notificationType": notificationType.name,
    };
  }

  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(final Object other) => other.runtimeType == Notification && hashCode == other.hashCode;
}
