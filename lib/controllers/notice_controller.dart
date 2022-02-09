import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';

class NoticeController extends GetxController {
  final Map<String, bool> _readMap = <String, bool>{};

  Future<void> updateReadMap() async {
    final studentId = Get.find<UserDataController>().studentId.toString();
    final noticeList = (await FirebaseFirestore.instance.collection("notices").get()).docs;
    final readList = (await FirebaseFirestore.instance.collection("users").doc(studentId).get())["readList"] as List;
    for (var notice in noticeList) {
      final noticeRef = FirebaseFirestore.instance.collection("notices").doc(notice.id);
      _readMap[notice.id] = readList.contains(noticeRef);
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getNoticeList() async {
    await updateReadMap();
    return (await FirebaseFirestore.instance.collection("notices").get()).docs;
  }

  Future<void> markRead(final String noticeId) async {
    final studentId = Get.find<UserDataController>().studentId.toString();
    final noticeRef = FirebaseFirestore.instance.collection("notices").doc(noticeId);
    await FirebaseFirestore.instance.collection("users").doc(studentId).update({
      "readList": FieldValue.arrayUnion([noticeRef])
    });

    _readMap[noticeId] = true;
    update();
  }

  bool isNew(final String noticeId) {
    return _readMap[noticeId] == false;
  }

  int unreadCount() {
    int unread = 0;
    for (bool value in _readMap.values) {
      unread += (value == false) ? 1 : 0;
    }
    return unread;
  }
}
