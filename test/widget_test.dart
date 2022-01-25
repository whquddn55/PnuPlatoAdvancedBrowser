import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:better_player/better_player.dart';

void main() => runApp(const TestApp());

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: const Root(),
    );
  }
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late List<GlobalKey<NavigatorState>> _navigatorKeyList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BetterPlayer.network(
            "https://nqvojgbmnbvt8379921.cdn.ntruss.com/hls/0e1541f7-3b98-4a48-8ef4-b68e17b6bec3/mp4/0e1541f7-3b98-4a48-8ef4-b68e17b6bec3.mp4/index.m3u8"),
      ),
    );
  }
}
