import 'package:permission_handler/permission_handler.dart';

abstract class PermissionController {
  static Future<PermissionStatus> requestPermission() async {
    var permissions = [Permission.storage];
    PermissionStatus res = PermissionStatus.granted;
    for (var permission in permissions) {
      var result = await permission.request();
      if (result == PermissionStatus.permanentlyDenied) {
        res = PermissionStatus.permanentlyDenied;
      } else if ((res != PermissionStatus.permanentlyDenied) && (result != PermissionStatus.granted)) {
        res = PermissionStatus.denied;
      }
    }
    return res;
  }
}
