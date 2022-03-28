import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/appbar_wrapper.dart';
import 'package:pnu_plato_advanced_browser/pages/settingPage/sections/setting_checkbox.dart';
import 'package:pnu_plato_advanced_browser/pages/settingPage/sections/setting_dropdown.dart';
import 'package:pnu_plato_advanced_browser/pages/settingPage/sections/setting_title.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        title: "세팅",
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              const SettingTitle(title: "자동 동기화"),
              const SettingCheckBox(title: "활성화", checked: true),
              const SettingTitle(title: "기타"),
              SettingDropdown(
                title: "테마",
                itemList: const ["화이트", "다크", "시스템"],
                onChanged: (index) => null, //_setTheme(context, index),
                initialIndex: 1,
              ),
            ],
          ),
          Container(color: Colors.grey.withOpacity(0.7), child: const Center(child: Text("아직 준비중이예요... 저 노력할게요...")))
        ],
      ),
    );
  }

  // Future<bool> _setTheme(BuildContext context, int index) async {
  //   return await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           content: const Text("앱이 재시작 됩니다."),
  //           actions: [
  //             TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context, false)),
  //             TextButton(
  //               child: const Text("확인"),
  //               onPressed: () {
  //                 if (index == 0) {
  //                   AppSettingController.themeMode = ThemeMode.light;
  //                 } else if (index == 1) {
  //                   AppSettingController.themeMode = ThemeMode.dark;
  //                 } else if (index == 2) {
  //                   AppSettingController.themeMode = ThemeMode.system;
  //                 }
  //                 Navigator.pop(context, true);
  //               },
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false;
  // }
}
