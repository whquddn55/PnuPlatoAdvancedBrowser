import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class FindInformationPage extends StatelessWidget {
  final String? url = {
    'id' : 'https://u-pip.pusan.ac.kr/rSSO/popup/FindID_step1.asp',
    'pw' : 'https://u-pip.pusan.ac.kr/rSSO/popup/FindPassword_step1.asp',
  }[Get.parameters['target']];

  InAppWebViewController? _webViewController;

  FindInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(await _webViewController!.canGoBack()){
          _webViewController!.goBack();
          return Future.value(false);
        }else{
          return Future.value(true);
        }
      },
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url ?? '')),
        initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(
              displayZoomControls: true,
            )
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          await controller.evaluateJavascript(source: "for (let e of document.getElementsByClassName('btn')) {  if (e.href == 'javascript:window.open(\\'\\', \\'_self\\').close();') e.href = 'javascript:console.log(\\'ppab:close\\')' }");
        },
        onConsoleMessage: (controller, msg) {
          if (msg.message == 'ppab:close') {
            Get.back();
          }
        },
      ),
    );
  }
}
