import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/controllers/app_setting_controller.dart';
import 'package:pnu_plato_advanced_browser/pages/settingPage/sections/setting_checkbox.dart';
import 'package:pnu_plato_advanced_browser/pages/settingPage/sections/setting_dropdown.dart';
import 'package:pnu_plato_advanced_browser/pages/settingPage/sections/setting_title.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("세팅"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          const SettingTitle(title: "자동 동기화"),
          const SettingCheckBox(title: "활성화", checked: true),
          const SettingTitle(title: "기타"),
          SettingDropdown(
            title: "테마",
            itemList: const ["화이트", "다크", "시스템"],
            onChanged: (index) => _setTheme(context, index),
            initialIndex: (AppSettingController.themeMode.index + 2) % 3,
          ),
        ],
      ),
    );
  }

  Future<bool> _setTheme(BuildContext context, int index) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text("앱이 재시작 됩니다."),
            actions: [
              TextButton(child: const Text("취소"), onPressed: () => Navigator.pop(context, false)),
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  if (index == 0) {
                    AppSettingController.themeMode = ThemeMode.light;
                  } else if (index == 1) {
                    AppSettingController.themeMode = ThemeMode.dark;
                  } else if (index == 2) {
                    AppSettingController.themeMode = ThemeMode.system;
                  }
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ) ??
        false;
  }
}
