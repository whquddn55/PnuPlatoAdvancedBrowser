import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pnu_plato_advanced_browser/common.dart';

class VodPage extends StatelessWidget {
  final String id;
  const VodPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? webViewController;
    return WillPopScope(
      onWillPop: () async {
        bool isFull = await webViewController!.evaluateJavascript(source: "document.fullscreen");
        if (isFull) {
          await webViewController!.evaluateJavascript(source: "document.exitFullscreen();");
          return false;
        }
        /* TODO: Show Dialog */
        return true;
      },
      child: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(CommonUrl.vodViewerUrl + id)),
          initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
            displayZoomControls: true,
          )),
          onWebViewCreated: (InAppWebViewController controller) {
            webViewController = controller;
          },
        ),
      ),
    );
  }
}
