import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/pages/loading_page.dart';

class VodPage extends StatefulWidget {
  final String id;
  const VodPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<VodPage> createState() => _VodPageState();
}

class _VodPageState extends State<VodPage> {
  InAppWebViewController? webViewController;
  final _loaderKey = GlobalKey<__LoaderState>();
  @override
  Widget build(BuildContext context) {
    final webViewWidget = WillPopScope(
      onWillPop: () async {
        bool? result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text("동영상을 종료합니다.\n출석여부를 꼭 확인해주세요!"),
            actions: [
              TextButton(
                child: const Text("취소"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("확인"),
                onPressed: () => Navigator.pop(context, true),
              )
            ],
          ),
        );
        return result == true;
      },
      child: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(CommonUrl.vodViewerUrl + widget.id)),
              onWebViewCreated: (InAppWebViewController controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, uri) {
                _loaderKey.currentState!.setLoading();
              },
              onLoadStop: (controller, uri) async {
                await controller.evaluateJavascript(
                  source: "function sleep(t){return new Promise(resolve=>setTimeout(resolve,t));}",
                );
                await controller.evaluateJavascript(
                  source: '''async function ppab() {
                            while (document.getElementsByClassName('vjs-fullscreen-control').length == 0){ 
                              await sleep(100); 
                              } 
                              document.getElementsByClassName('vjs-fullscreen-control')[0].remove();};''',
                );
                await controller.evaluateJavascript(
                  source: "ppab();",
                );

                await controller.evaluateJavascript(source: '''
    var viewHeight = document.getElementById('vod_viewer').clientHeight;
                        var headHeight = document.getElementById('vod_header').clientHeight;
                        var footHeight = document.getElementById('vod_footer').clientHeight;
                        document.getElementById('vod_header').remove();
                        document.getElementById('vod_footer').remove();
                        document.getElementById('vod_viewer').style.height = viewHeight + headHeight + footHeight + 'px';
                        document.getElementById('vod_viewer').style.position = 'absolute';
                        document.getElementById('vod_viewer').style.top = '0px';
                        ''');

                _loaderKey.currentState!.setLoaded();
              },
            ),
            _Loader(key: _loaderKey),
          ],
        ),
      ),
    );
    return OrientationBuilder(builder: (context, orientation) {
      double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
      webViewController?.evaluateJavascript(source: "document.getElementById('vod_viewer').style.height = $height + 'px'");
      return webViewWidget;
    });
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
    return loading ? const Material(child: LoadingPage(msg: "웹페이지를 로딩중입니다...")) : const SizedBox.shrink();
  }
}
