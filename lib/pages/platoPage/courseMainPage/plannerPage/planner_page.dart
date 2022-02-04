import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PlannerPage extends StatelessWidget {
  final String title;
  final Uri uri;

  const PlannerPage({Key? key, required this.title, required this.uri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final InAppWebViewController _webViewController;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
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
          initialUrlRequest: URLRequest(url: uri),
          initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
            displayZoomControls: true,
          )),
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onLoadStop: (controller, url) async {
            await controller.evaluateJavascript(
              source: "function sleep(t){return new Promise(resolve=>setTimeout(resolve,t));}",
            );
            await controller.evaluateJavascript(
              source:
                  "async function ppab() {while (document.getElementsByClassName('crownix-close-button').length == 0){ await sleep(100); } document.getElementsByClassName('crownix-close-button')[0].remove();document.getElementById('crownix-html5-viewer').attributeStyleMap.clear();document.getElementsByClassName('crownix-overlay')[0].remove();document.getElementById('wrapper').remove();};",
            );
            await controller.evaluateJavascript(
              source: "ppab();",
            );
          },
        ),
      ),
    );
  }
}
