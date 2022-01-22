import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PlannerPage extends StatelessWidget {
  final String title;
  final Uri uri;

  InAppWebViewController? _webViewController;

  PlannerPage({Key? key, required this.title, required this.uri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (await _webViewController!.canGoBack()) {
            _webViewController!.goBack();
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
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;
          },
          onLoadStop: (controller, url) async {
            await controller.evaluateJavascript(
              source: "function sleep(t){return new Promise(resolve=>setTimeout(resolve,t));}",
            );
            await controller.evaluateJavascript(
              source:
                  "async function ppab() {while (document.getElementsByClassName('crownix-close-button').length == 0){ await sleep(100); } document.getElementsByClassName('crownix-close-button')[0].addEventListener('click', (event) => {console.log('ppab:close')})};",
            );
            await controller.evaluateJavascript(
              source: "ppab();",
            );
          },
          onConsoleMessage: (controller, msg) {
            print(msg);
            if (msg.message == 'ppab:close') {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
