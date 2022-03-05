enum NotificationType { ubboard, ubfile, zoom, vod, folder, url }

class Notification {
  final String title;
  final String body;
  final String url;
  final NotificationType notificationType;

  Notification({required this.title, required this.body, required this.url, required this.notificationType});

  Notification.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        body = json["body"],
        url = json["url"],
        notificationType = NotificationType.values.byName(json["notificationType"]);

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "url": url,
      "notificationType": notificationType.name,
    };
  }

  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(final Object other) => other.runtimeType == Notification && hashCode == other.hashCode;
}
