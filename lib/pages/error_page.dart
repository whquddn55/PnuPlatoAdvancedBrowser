import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorPage extends StatelessWidget {
  final String msg;
  const ErrorPage({Key? key, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("에러"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorWidget(),
            Text(msg),
          ],
        ),
      ),
    );
  }
}

Widget errorWidget() {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [SvgPicture.asset("assets/icons/lobster.svg", height: 25, width: 25, color: Colors.red), const Text("어라라...ㅂ스타?")]);
}
