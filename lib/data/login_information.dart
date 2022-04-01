import 'package:objectbox/objectbox.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/storage_controller.dart';
import 'package:pnu_plato_advanced_browser/objectbox.g.dart';

@Entity()
class LoginInformation {
  @Id(assignable: true)
  int dbId = StorageController.defaultUserDataId;
  bool loginStatus;
  String sessionKey;
  String moodleSessionKey;
  String loginMsg;

  String studentId;
  String name;
  String department;
  String imgUrl;

  LoginInformation({
    this.loginStatus = false,
    this.sessionKey = '',
    this.moodleSessionKey = '',
    this.loginMsg = '',
    this.studentId = '학번',
    this.name = '이름',
    this.department = '학과(전공)',
    this.imgUrl = CommonUrl.defaultAvatarUrl,
  });

  @override
  String toString() => {
        "loginStatus": loginStatus,
        "sessionKey": sessionKey,
        "moodleSessionKey": moodleSessionKey,
        "loginMsg": loginMsg,
        "studentId": studentId,
        "name": name,
        "department": department,
        "imgUrl": imgUrl,
      }.toString();
}
