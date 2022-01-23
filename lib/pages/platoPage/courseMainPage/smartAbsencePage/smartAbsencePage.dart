import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/controllers/userDataController.dart';
import 'package:pnu_plato_advanced_browser/pages/loadingPage.dart';

class SmartAbsencePage extends StatelessWidget {
  final String courseId;
  InAppWebViewController? _webViewController;

  SmartAbsencePage({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CookieManager cookieManager = CookieManager.instance();
    return FutureBuilder(
      future: Future.wait([
        cookieManager.deleteAllCookies(),
        cookieManager.setCookie(
          url: Uri.parse('https://plato.pusan.ac.kr'),
          name: 'MoodleSession',
          value: Get.find<UserDataController>().moodleSessionKey.split('=')[1],
          domain: 'plato.pusan.ac.kr',
          path: '/',
        ),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('스마트 출석부'),
              centerTitle: true,
            ),
            extendBodyBehindAppBar: true,
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
                initialUrlRequest: URLRequest(url: Uri.parse(CommonUrl.courseSmartAbsenceUrl + courseId)),
                initialOptions: InAppWebViewGroupOptions(
                    android: AndroidInAppWebViewOptions(
                  displayZoomControls: true,
                )),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) async {
                  await controller.evaluateJavascript(
                    source: "document.getElementById('page-header').remove();document.getElementsByClassName('page-content-navigation')[0].remove();",
                  );
                },
                onLoadStop: (controller, url) async {
                  await controller.evaluateJavascript(
                    source: "document.getElementById('page-header').remove();document.getElementsByClassName('page-content-navigation')[0].remove();",
                  );
                },
              ),
            ),
          );
        } else {
          return const LoadingPage(msg: '로딩중 ...');
        }
      },
    );
  }
}
