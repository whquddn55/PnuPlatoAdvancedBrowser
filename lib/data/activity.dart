class Activity {
  final String type;
  final String title;
  final String id;
  final String courseId;
  final String description;
  final String? info;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? lateDate;
  final Uri? iconUri;
  bool done;
  Activity({
    required this.type,
    required this.title,
    required this.id,
    required this.courseId,
    this.startDate,
    this.endDate,
    this.lateDate,
    required this.description,
    this.info,
    this.iconUri,
    this.done = false,
  });
}
