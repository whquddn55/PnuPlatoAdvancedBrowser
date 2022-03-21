import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';

class NavigatorBody extends StatefulWidget {
  const NavigatorBody({Key? key}) : super(key: key);

  @override
  State<NavigatorBody> createState() => _NavigatorBodyState();
}

class _NavigatorBodyState extends State<NavigatorBody> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: RouteController.to.pages.length, vsync: this);
    DateTime? currentBackPressTime;
    return GetBuilder<RouteController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            bool res = !(await controller.maybePop());

            if (res == true) {
              if (controller.currentIndex != 0) {
                controller.currentIndex = 0;
                tabController.animateTo(0);
                res = false;
              }
            }
            if (res == true) {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
                currentBackPressTime = now;
                Fluttertoast.showToast(msg: "버튼을 한번 더 누르면 종료됩니다.", backgroundColor: Colors.black.withOpacity(0.5));
                res = false;
              }
            }
            return res;
          },
          child: Scaffold(
            body: TabBarView(
              controller: tabController,
              children: controller.pages,
              physics: const NeverScrollableScrollPhysics(),
            ),
            bottomNavigationBar: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              reverseDuration: const Duration(milliseconds: 50),
              child: TabBar(
                controller: tabController,
                onTap: (index) {
                  controller.currentIndex = index;
                  //tabController.animateTo(index);
                },
                indicator: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Get.theme.colorScheme.secondary,
                      width: 3.0,
                    ),
                  ),
                ),
                tabs: const [
                  Tab(child: Icon(Icons.home)),
                  Tab(child: Icon(Icons.calendar_today_outlined)),
                  Tab(child: Icon(Icons.email)),
                  Tab(child: Icon(Icons.download_rounded)),
                  Tab(child: Icon(Icons.notifications)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
