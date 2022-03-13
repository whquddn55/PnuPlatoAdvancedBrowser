import 'package:pnu_plato_advanced_browser/common.dart';

class LoginInformation {
  bool loginStatus;
  String sessionKey;
  String moodleSessionKey;
  String loginMsg;

  String studentId;
  String name;
  String department;
  String imgUrl;
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

  LoginInformation.fromJson(Map<String, dynamic> json)
      : loginStatus = json["loginStatus"],
        sessionKey = json["sessionKey"],
        moodleSessionKey = json["moodleSessionKey"],
        loginMsg = json["loginMsg"],
        studentId = json["studentId"],
        name = json["name"],
        department = json["department"],
        imgUrl = json["imgUrl"],
        lastSyncTime = json["lastSyncTime"];

  Map<String, dynamic> toJson() => {
        "loginStatus": loginStatus,
        "sessionKey": sessionKey,
        "moodleSessionKey": moodleSessionKey,
        "loginMsg": loginMsg,
        "studentId": studentId,
        "name": name,
        "department": department,
        "imgUrl": imgUrl,
        "lastSyncTime": lastSyncTime,
      };

  @override
  String toString() => toJson().toString();
}
