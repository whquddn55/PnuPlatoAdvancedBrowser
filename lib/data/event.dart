enum EventType { video, assign, zoom, quiz }

class Event {
  final EventType type;
  final String title;
  final String id;
  final String courseId;
  final DateTime dueDate;
  bool done;
  Event({
    required this.type,
    required this.title,
    required this.id,
    required this.courseId,
    required this.dueDate,
    this.done = false
  });
}