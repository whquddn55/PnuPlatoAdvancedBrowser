import 'package:isar/isar.dart';

part 'user_data.g.dart';

@Collection()
class UserData {
  @Id()
  final int isarId = 0;
  String username = "";
  String password = "";
  bool isFirst = true;
  DateTime lastSyncTime = DateTime(2000);
}
