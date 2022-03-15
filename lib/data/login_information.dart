import 'package:hive_flutter/adapters.dart';
import 'package:pnu_plato_advanced_browser/common.dart';

part 'login_information.g.dart';

@HiveType(typeId: 14)
class LoginInformation {
  @HiveField(0)
  bool loginStatus;
  @HiveField(1)
  String sessionKey;
  @HiveField(2)
  String moodleSessionKey;
  @HiveField(3)
  String loginMsg;

  @HiveField(4)
  String studentId;
  @HiveField(5)
  String name;
  @HiveField(6)
  String department;
  @HiveField(7)
  String imgUrl;
  @HiveField(8)
  String lastSyncTime;

  LoginInformation({
    this.loginStatus = false,
    this.sessionKey = '',
    this.moodleSessionKey = '',
    this.loginMsg = '',
    this.studentId = '학번',
    this.name = 'thuthi',
    this.department = '전기컴퓨터공학부',
    this.imgUrl = CommonUrl.defaultAvatarUrl,
    this.lastSyncTime = "1946-05-15 00:00:00.000",
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
        "lastSyncTime": lastSyncTime,
      }.toString();
}
