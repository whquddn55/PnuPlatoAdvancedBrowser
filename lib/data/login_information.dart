import 'package:isar/isar.dart';
import 'package:pnu_plato_advanced_browser/common.dart';

part 'login_information.g.dart';

@Collection()
class LoginInformation {
  @Id()
  final int isarId = 0;
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
    this.name = 'thuthi',
    this.department = '전기컴퓨터공학부',
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
