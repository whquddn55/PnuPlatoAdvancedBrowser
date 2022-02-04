class CourseArticle {
  final String title;
  final String writer;
  final String date;
  final String boardId;
  final String id;

  CourseArticle({
    required this.title,
    this.writer = '',
    required this.date,
    required this.boardId,
    this.id = '',
  });
}
