import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final String msg;
  const LoadingPage({Key? key, this.msg = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Text(msg)
        ],
      ),
    );
  }
}
