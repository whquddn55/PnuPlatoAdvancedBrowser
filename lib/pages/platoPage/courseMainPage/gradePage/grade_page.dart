import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pnu_plato_advanced_browser/common.dart';

class GradePage extends StatelessWidget {
  final String courseId;

  const GradePage({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final InAppWebViewController _webViewController;
    return Scaffold(
      appBar: AppBar(
        title: const Text('성적'),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: WillPopScope(
        onWillPop: () async {
          if (await _webViewController.canGoBack()) {
            _webViewController.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(CommonUrl.courseGradeUrl + courseId)),
          initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
            displayZoomControls: true,
          )),
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onLoadStop: (controller, url) async {
            await controller.evaluateJavascript(
              source: "document.getElementById('page-header').remove();document.getElementsByClassName('page-content-navigation')[0].remove();",
            );
          },
        ),
      ),
    );
  }
}
