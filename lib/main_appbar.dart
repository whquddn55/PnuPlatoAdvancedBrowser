import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/appbar_wrapper.dart';
import 'package:pnu_plato_advanced_browser/controllers/notice_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/login_controller.dart';

class MainAppbar extends AppBarWrapper {
  MainAppbar(final String titleText, {Key? key, final PreferredSizeWidget? bottomWidget})
      : super(
          key: key,
          title: titleText,
          bottom: bottomWidget,
          leading: GetBuilder<LoginController>(builder: (userDataController) {
            if (userDataController.loginInformation.loginStatus == false) {
              return Builder(builder: (context) {
                return IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer());
              });
            }

            Get.find<NoticeController>().updateReadMap();
            return GetBuilder<NoticeController>(builder: (controller) {
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection("users").doc(userDataController.loginInformation.studentId.toString()).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.active || snapshot.data == null) {
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
            });
          }),
        );
}
