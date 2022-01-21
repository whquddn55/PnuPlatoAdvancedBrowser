import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoadingPage extends StatelessWidget {
  final String msg;
  const LoadingPage({Key? key, this.msg = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitRing(
              color: Get.theme.primaryColor,
              lineWidth: 4.0,
            ),
            Text(msg)
          ],
        )
      )
    );
  }
}
