class Activity {
  final String type;
  final String title;
  final String id;
  final String courseId;
  final String description;
  final String info;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? lateDate;
  final Uri? iconUri;
  final String availablilityInfo;
  final bool availablility;

  Activity({
    required this.type,
    required this.title,
    required this.id,
    required this.courseId,
    this.startDate,
    this.endDate,
    this.lateDate,
    required this.description,
    required this.info,
    this.iconUri,
    this.availablilityInfo = '',
    this.availablility = true,
  });
}
