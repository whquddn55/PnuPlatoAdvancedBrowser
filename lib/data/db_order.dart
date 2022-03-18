import 'package:objectbox/objectbox.dart';

@Entity()
class DBOrder {
  @Id(assignable: true)
  int id;
  final List<String> idList;

  DBOrder({required this.id, required this.idList});
}
