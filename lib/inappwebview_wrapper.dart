import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';

class InappwebviewWrapper extends StatelessWidget {
  final String title;
  final String url;
  final Function(InAppWebViewController, Uri?)? onLoadStop;
  final bool preventRedirect;
  final bool scaffolded;
  final bool alwaysPop;
  const InappwebviewWrapper(
    this.title,
    this.url,
    this.onLoadStop, {
    Key? key,
    this.preventRedirect = false,
    this.scaffolded = false,
    this.alwaysPop = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? _webViewController;
    final loaderKey = GlobalKey<__LoaderState>();
    final Widget body = WillPopScope(
      onWillPop: () async {
        if (alwaysPop) {
          return true;
        }
        if (await _webViewController!.canGoBack()) {
          _webViewController!.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(url)),
            initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            )),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, uri) async {
              if (preventRedirect && (uri.toString() != url)) Navigator.pop(context);

              loaderKey.currentState!.setLoading();
            },
            onLoadStop: (controller, uri) async {
              if (onLoadStop != null) {
                await onLoadStop!(controller, uri);
              }
              loaderKey.currentState!.setLoaded();
            },
            onConsoleMessage: (controller, msg) {
              if (msg.message == 'ppab:close') {
                Navigator.pop(context);
              }
            },
            // onDownloadStart: (controller, uri) {
            //   Get.find<DownloadController>().enQueue()
            //   print(uri);
            // },
            // onAjaxProgress: (a, b) async {
            //   printLog("onAjaxProgress");
            //   return AjaxRequestAction.PROCEED;
            // },
            // onAjaxReadyStateChange: (a, b) async {
            //   printLog("onAjaxReadyStateChange");
            // },
            // onCloseWindow: (a) async {
            //   printLog("onCloseWindow");
            // },
            // onCreateWindow: (a, b) async {
            //   printLog("onCreateWindow");
            // },
            // onEnterFullscreen: (a) {
            //   printLog("onEnterFullscreen");
            // },
            // onExitFullscreen: (a) {
            //   printLog("onExitFullscreen");
            // },
            // onFindResultReceived: (a, b, c, d) {
            //   printLog("onFindResultReceived");
            // },
            // onJsAlert: (a, b) async {
            //   printLog("onJsAlert");
            // },
            // onJsConfirm: (a, b) async {
            //   printLog("onJsConfirm");
            // },
            // onJsPrompt: (a, b) async {
            //   printLog("onJsPrompt");
            // },
            // onLoadError: (a, b, c, d) async {
            //   printLog("onLoadError");
            // },
            // onLoadHttpError: (a, b, c, d) async {
            //   printLog("onLoadHttpError");
            // },
            // onLoadResource: (a, b) async {
            //   printLog("onLoadResource");
            // },
            // onLoadResourceCustomScheme: (a, b) async {
            //   printLog("onLoadResourceCustomScheme");
            // },
            // onLongPressHitTestResult: (a, b) async {
            //   printLog("onLongPressHitTestResult");
            // },
            // onOverScrolled: (a, b, c, d, e) async {
            //   printLog("onOverScrolled");
            // },
            // onPageCommitVisible: (a, b) async {
            //   printLog("onPageCommitVisible");
            // },
            // onPrint: (a, b) async {
            //   printLog("onPrint");
            // },
            // onProgressChanged: (a, b) async {
            //   printLog("onProgressChanged");
            // },
            // onReceivedClientCertRequest: (a, b) async {
            //   printLog("onReceivedClientCertRequest");
            // },
            // onReceivedHttpAuthRequest: (a, b) async {
            //   printLog("onReceivedHttpAuthRequest");
            // },
            // onReceivedServerTrustAuthRequest: (a, b) async {
            //   printLog("onReceivedServerTrustAuthRequest");
            // },
            // onScrollChanged: (a, b, c) async {
            //   printLog("onScrollChanged");
            // },
            // onTitleChanged: (a, b) async {
            //   printLog("onTitleChanged");
            // },
            // onUpdateVisitedHistory: (a, b, c) async {
            //   printLog("onUpdateVisitedHistory");
            // },
            // onWindowBlur: (a) async {
            //   printLog("onWindowBlur");
            // },
            // onWindowFocus: (a) async {
            //   printLog("onWindowFocus");
            // },
            // onZoomScaleChanged: (a, b, c) async {
            //   printLog("onZoomScaleChanged");
            // },
            // initialOptions: InAppWebViewGroupOptions(
            //     crossPlatform: InAppWebViewOptions(
            //   allowFileAccessFromFileURLs: true,
            //   allowUniversalAccessFromFileURLs: true,
            //   javaScriptCanOpenWindowsAutomatically: true,
            //   useOnDownloadStart: true,
            //   useOnLoadResource: true,
            //   javaScriptEnabled: true,

            // )),
          ),
          _Loader(key: loaderKey),
        ],
      ),
    );

    if (scaffolded) {
      return body;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: body,
    );
  }
}

class _Loader extends StatefulWidget {
  const _Loader({Key? key}) : super(key: key);

  @override
  __LoaderState createState() => __LoaderState();
}

class __LoaderState extends State<_Loader> {
  bool loading = true;

  void setLoading() {
    setState(() {
      loading = true;
    });
  }

  void setLoaded() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? const Scaffold(body: LoadingPage(msg: "웹페이지를 로딩중입니다...")) : const SizedBox.shrink();
  }
}
