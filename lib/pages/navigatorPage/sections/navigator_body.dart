import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/controllers/download_controller.dart';
import 'package:pnu_plato_advanced_browser/controllers/route_controller.dart';
import 'package:pnu_plato_advanced_browser/data/download_information.dart';

class NavigatorBody extends StatelessWidget {
  const NavigatorBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RouteController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            return !(await controller.maybePop());
          },
          child: DefaultTabController(
            length: controller.pages.length,
            child: Scaffold(
              body: TabBarView(
                children: controller.pages,
                physics: const NeverScrollableScrollPhysics(),
              ),
              bottomNavigationBar: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                reverseDuration: const Duration(milliseconds: 50),
                child: TabBar(
                  onTap: (index) => controller.currentIndex = index,
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
          ),
        );
      },
    );
  }
}
