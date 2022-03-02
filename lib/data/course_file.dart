class CourseFile {
  final String imgUrl;
  final String url;
  final String title;

  CourseFile({
    required this.imgUrl,
    required this.url,
    required this.title,
  });

  @override
  String toString() {
    return 'imgUrl: $imgUrl, url: $url, title: $title';
  }
}
