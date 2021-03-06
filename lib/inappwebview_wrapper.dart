import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pnu_plato_advanced_browser/appbar_wrapper.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';

class InappwebviewWrapper extends StatefulWidget {
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
  State<InappwebviewWrapper> createState() => _InappwebviewWrapperState();
}

class _InappwebviewWrapperState extends State<InappwebviewWrapper> {
  late final InAppWebViewController _webViewController;
  late final PullToRefreshController _pullToRefreshController;

  @override
  void initState() {
    _pullToRefreshController = PullToRefreshController(onRefresh: () async {
      await _webViewController.reload();
      await _pullToRefreshController.endRefreshing();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loaderKey = GlobalKey<__LoaderState>();
    final Widget body = WillPopScope(
      onWillPop: () async {
        if (widget.alwaysPop) {
          return true;
        }
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Stack(
        children: [
          InAppWebView(
            pullToRefreshController: _pullToRefreshController,
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            )),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, uri) async {
              if (widget.preventRedirect && (uri.toString() != widget.url)) Navigator.pop(context);

              loaderKey.currentState!.setLoading();
            },
            onLoadStop: (controller, uri) async {
              if (widget.onLoadStop != null) {
                await widget.onLoadStop!(controller, uri);
              }
              await controller.scrollTo(x: 0, y: 0);

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

    if (widget.scaffolded) {
      return body;
    }
    return Scaffold(
      appBar: AppBarWrapper(
        title: widget.title,
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
    return loading ? const Scaffold(body: LoadingPage(msg: "??????????????? ??????????????????...")) : const SizedBox.shrink();
  }
}
