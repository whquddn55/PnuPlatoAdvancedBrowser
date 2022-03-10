import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("구현할 시간이 없네요... 살려주세요"),
          ],
        ),
      ),

      // LoginBuilderPage(() => ListView(
      //       children: const [],
      //     )),
    );
  }
}
