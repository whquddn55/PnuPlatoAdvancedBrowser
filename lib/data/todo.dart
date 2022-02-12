enum TodoType { vod, assign, quiz, zoom }
enum TodoStatus { done, undone, doing }

class Todo {
  final String id;
  final String title;
  final String courseId;
  final DateTime dueDate;
  final TodoType type;
  final bool availability;
  final Uri iconUri;
  TodoStatus status;

  Todo({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    required this.type,
    required this.availability,
    required this.iconUri,
    required this.status,
  });
}
