import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/notice_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/user_data_controller.dart';

class MainAppbar extends AppBar {
  MainAppbar(final String titleText, {Key? key, final PreferredSizeWidget? bottomWidget})
      : super(
          key: key,
          elevation: 0.0,
          title: Text(titleText),
          centerTitle: true,
          leading: GetBuilder<NoticeController>(builder: (controller) {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("users").doc(Get.find<UserDataController>().studentId.toString()).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer());
                }
                int unread = snapshot.data!["unread"] + controller.unreadCount();
                return IconButton(
                  icon: Badge(
                    child: const Icon(Icons.menu),
                    badgeContent: Text(unread.toString()),
                    showBadge: unread != 0,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            );
          }),
        ) {
    Get.find<NoticeController>().updateReadMap();
  }
}
