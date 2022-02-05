import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingTitle extends StatelessWidget {
  final String title;
  const SettingTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.backgroundColor,
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
