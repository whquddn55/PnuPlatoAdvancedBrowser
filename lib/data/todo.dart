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

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != Todo) return false;
    var otherTodo = other as Todo;
    return otherTodo.id == id && otherTodo.courseId == courseId && otherTodo.type == type;
  }

  Todo.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        courseId = json["courseId"],
        dueDate = DateTime.parse(json["dueDate"]),
        type = TodoType.values.byName(json["type"]),
        availability = json["availability"],
        iconUri = Uri.parse(json["iconUri"]),
        status = TodoStatus.values.byName(json["status"]);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "courseId": courseId,
      "dueDate": dueDate.toString(),
      "type": type.name,
      "availability": availability,
      "iconUri": iconUri.toString(),
      "status": status.name,
    };
  }
}
