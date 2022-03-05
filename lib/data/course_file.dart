class CourseFile {
  final String imgUrl;
  final String url;
  final String title;

  CourseFile({
    required this.imgUrl,
    required this.url,
    required this.title,
  });

  CourseFile.fromJson(Map<String, dynamic> json)
      : imgUrl = json["imgUrl"],
        title = json["title"],
        url = json["url"];

  Map<String, dynamic> toJson() {
    return {
      "imgUrl": imgUrl,
      "title": title,
      "url": url,
    };
  }
}
