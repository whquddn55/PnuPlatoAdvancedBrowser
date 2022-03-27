import 'package:objectbox/objectbox.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/objectbox.g.dart';

@Entity()
class UserData {
  @Id(assignable: true)
  int dbId = StorageController.defaultUserDataId;
  String username = "";
  String password = "";
  DateTime lastNotiSyncTime = DateTime(2000);
  DateTime lastTodoSyncTime = DateTime(2000);
}
