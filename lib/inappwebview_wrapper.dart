import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';

class InappwebviewWrapper extends StatelessWidget {
  final String title;
  final String url;
  final Function(InAppWebViewController, Uri?)? onLoadStop;
  final bool preventRedirect;
  const InappwebviewWrapper(this.title, this.url, this.onLoadStop, {Key? key, this.preventRedirect = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? _webViewController;
    final _loaderKey = GlobalKey<__LoaderState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (await _webViewController!.canGoBack()) {
            _webViewController!.goBack();
            return false;
          } else {
            Navigator.pop(context);
            return true;
          }
        },
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(url)),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, uri) async {
                if (preventRedirect && (uri.toString() != url)) Navigator.pop(context);

                _loaderKey.currentState!.setLoading();
              },
              onLoadStop: (controller, uri) async {
                if (onLoadStop != null) {
                  await onLoadStop!(controller, uri);
                }
                _loaderKey.currentState!.setLoaded();
              },
              onConsoleMessage: (controller, msg) {
                if (msg.message == 'ppab:close') {
                  Navigator.pop(context);
                }
              },
              onDownloadStart: (controller, uri) {
                print(uri);
              },
            ),
            _Loader(key: _loaderKey),
          ],
        ),
      ),
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
