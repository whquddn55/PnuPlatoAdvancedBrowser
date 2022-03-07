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
                child: controller.showBottomNavBar == false
                    ? const SizedBox.shrink()
                    : TabBar(
                        onTap: (index) => controller.currentIndex = index,
                        indicator: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Get.theme.colorScheme.secondary,
                              width: 3.0,
                            ),
                          ),
                        ),
                        tabs: [
                          const Tab(child: Icon(Icons.home)),
                          const Tab(child: Icon(Icons.calendar_today_outlined)),
                          const Tab(child: Icon(Icons.email)),
                          Tab(
                            child: StreamBuilder<List<DownloadInformation>>(
                              stream: Get.find<DownloadController>().stream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.active) {
                                  List<DownloadInformation> list = snapshot.data!;
                                  return Badge(
                                    badgeContent: Text(list.length.toString()),
                                    child: const Icon(Icons.download_rounded),
                                    showBadge: list.isNotEmpty,
                                  );
                                } else {
                                  return const Icon(Icons.download_rounded);
                                }
                              },
                            ),
                          ),
                          const Tab(child: Icon(Icons.notifications)),
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
