import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pnu_plato_advanced_browser/common.dart';

abstract class ExceptionController {
  static Future<void> onExpcetion(final String subject, final String body) async {
    final progressContext = await showProgressDialog(Get.key.currentContext!, "");
    bool sendResult = await sendMail(subject, body);
    closeProgressDialog(progressContext);
    await Get.dialog(
      AlertDialog(
        title: const Text("에러"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("에러가 발생했어요!${sendResult == true ? "\n개발자에게 관련 내용을 보냈습니다." : ""}"),
              ExpandedTile(
                title: const Text("내용 확인하기"),
                content: Text(subject + "\n" + body, style: const TextStyle(fontSize: 8)),
                controller: ExpandedTileController(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("확인"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      barrierDismissible: false,
      navigatorKey: Get.key,
    );
  }

  static Future<bool> sendMail(final String subject, final String body) async {
    try {
      final smtpServer = SmtpServer("smtp.gmail.com", username: "ppab.thuthi@gmail.com", password: "bzfhkpwuyvgellgz");
      final message = Message()
        ..from = const Address("ppab.thuthi@gmail.com", "ppab")
        ..recipients.add("whquddn55@gmail.com")
        ..subject = subject
        ..text = body;
      await send(message, smtpServer);
    } on MailerException catch (_) {
      return false;
    }
    return true;
  }
}
