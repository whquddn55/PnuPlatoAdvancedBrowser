import 'package:objectbox/objectbox.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/objectbox.g.dart';

@Entity()
class UserData {
  @Id(assignable: true)
  int dbId = StorageController.defaultUserDataId;
  String username = "";
  String password = "";
  bool isFirst = true;
  DateTime lastSyncTime = DateTime(2000);
}
