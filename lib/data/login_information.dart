import 'package:pnu_plato_advanced_browser/common.dart';

class LoginInformation {
  bool loginStatus = false;
  String sessionKey = '';
  String moodleSessionKey = '';
  String loginMsg = '';
  String debugMsg = '';

  int studentId = 123456789;
  String name = 'thuthi';
  String department = '전기컴퓨터공학부';
  String imgUrl = CommonUrl.defaultAvatarUrl;
  String lastSyncTime = DateTime(1946, 05, 15).toString();
}
