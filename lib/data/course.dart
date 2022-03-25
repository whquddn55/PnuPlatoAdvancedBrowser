import 'package:objectbox/objectbox.dart';

@Entity()
class Course {
  @Id(assignable: true)
  int dbId;

  final String id;
  final String title;
  final String sub;

  Course({required this.title, required this.sub, required this.id}) : dbId = int.parse(id);
}
