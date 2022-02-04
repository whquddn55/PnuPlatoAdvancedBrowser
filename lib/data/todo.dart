enum TodoStatus { done, undone }

class Todo {
  final String id;
  final String title;
  final String courseId;
  final DateTime dueDate;
  TodoStatus status;

  Todo({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    this.status = TodoStatus.undone,
  });
}
