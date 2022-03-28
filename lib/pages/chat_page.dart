import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/inappwebview_wrapper.dart';
import 'package:pnu_plato_advanced_browser/main_appbar.dart';
import 'package:pnu_plato_advanced_browser/main_drawer.dart';
import 'package:pnu_plato_advanced_browser/pages/login_builder_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar("쪽지"),
      drawer: const MainDrawer(),
      body: LoginBuilderPage(() => InappwebviewWrapper(
            "쪽지",
            "https://plato.pusan.ac.kr/local/ubmessage/",
            (controller, uri) async {
              await controller.evaluateJavascript(source: '''document.getElementById('page-header').remove();
            document.body.style.margin = '0px';
            document.body.style.padding = '0px';''');
            },
            scaffolded: true,
          )),
    );
  }
}
