import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionController {
  static Future<bool> requestPermission() async {
    var permissions = [Permission.storage];
    var res = true;
    for (var permission in permissions) {
      var result = await permission.request();
      if (result == PermissionStatus.permanentlyDenied) {
        res &= false;
        await showDialog(
          context: Get.context!,
          builder: (context) {
            return const AlertDialog(
              content: Text("앱 세팅 화면에서 권한을 모두 허용으로 바꾸어 주세요."),
            );
          },
        );
        openAppSettings();
      } else if ((result != PermissionStatus.permanentlyDenied) && (result != PermissionStatus.granted)) {
        res &= false;
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: '다운 받기 위해서는 권한이 필요합니다.');
      }
    }
    return res;
  }
}
