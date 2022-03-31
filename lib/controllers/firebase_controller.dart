import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/exception_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';

class FirebaseController extends GetxController {
  static FirebaseController get to => Get.find<FirebaseController>();
  final Map<String, bool> noticeMap = <String, bool>{};
  int unreadChatCount = 0;

  Future<void> initialize() async {
    final String studentId = LoginController.to.loginInformation.studentId;
    try {
      var doc = await FirebaseFirestore.instance.collection("users").doc(studentId).get();

      if (doc.exists == false) {
        await FirebaseFirestore.instance.collection("users").doc(studentId).set({
          "unread": 0,
          "adminUnread": 0,
          "time": Timestamp.now(),
          "readList": [],
        });
      }

      final noticeList = (await FirebaseFirestore.instance.collection("notices").get()).docs;
      final readList = (await FirebaseFirestore.instance.collection("users").doc(studentId).get())["readList"] as List;
      for (var notice in noticeList) {
        final noticeRef = FirebaseFirestore.instance.collection("notices").doc(notice.id);
        noticeMap[notice.id] = readList.contains(noticeRef);
      }

      unreadChatCount = (await FirebaseFirestore.instance.collection("users").doc(studentId).get())["unread"];
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + '\n' + stacktrace.toString(), true);
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchNoticeList() async {
    try {
      return (await FirebaseFirestore.instance.collection("notices").get()).docs;
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + '\n' + stacktrace.toString(), true);
    }
    return [];
  }

  Future<void> markNoticeRead(final String noticeId) async {
    try {
      final studentId = LoginController.to.loginInformation.studentId;
      final noticeRef = FirebaseFirestore.instance.collection("notices").doc(noticeId);
      await FirebaseFirestore.instance.collection("users").doc(studentId).update({
        "readList": FieldValue.arrayUnion([noticeRef])
      });
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + '\n' + stacktrace.toString(), true);
    }

    noticeMap[noticeId] = true;
    update();
  }

  int noticeUnreadCount() {
    int unread = 0;
    for (bool value in noticeMap.values) {
      unread += (value == false) ? 1 : 0;
    }
    return unread;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>?> getChatStream() {
    final studentId = LoginController.to.loginInformation.studentId;
    try {
      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(studentId)
          .collection('chats')
          .orderBy("time", descending: true)
          .snapshots()
          .handleError((error) {
        ExceptionController.onExpcetion(error.toString(), true);
      });
      return stream;
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + '\n' + stacktrace.toString(), true);
    }
    return Stream.value(null);
  }

  Future<void> markUserChatRead() async {
    try {
      final studentId = LoginController.to.loginInformation.studentId;
      final doc = FirebaseFirestore.instance.collection('users').doc(studentId);
      await doc.update({"unread": 0});
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + '\n' + stacktrace.toString(), true);
    }
    unreadChatCount = 0;
    update();
  }

  Future<void> markAdminChatRead() async {
    try {
      final studentId = LoginController.to.loginInformation.studentId;
      final doc = FirebaseFirestore.instance.collection('users').doc(studentId);
      await doc.update({"adminUnread": 0});
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + '\n' + stacktrace.toString(), true);
    }
  }

  Future<void> sendChat(bool isAdmin, String text) async {
    try {
      final studentId = LoginController.to.loginInformation.studentId;
      final doc = FirebaseFirestore.instance.collection('users').doc(studentId);
      await doc.collection('chats').add({
        "isUser": !isAdmin,
        "text": text,
        "time": Timestamp.now(),
      });
      doc.update({
        "time": Timestamp.now(),
        (isAdmin ? "unread" : "adminUnread"): FieldValue.increment(1),
      });
    } catch (e, stacktrace) {
      ExceptionController.onExpcetion(e.toString() + '\n' + stacktrace.toString(), true);
    }
  }
}
