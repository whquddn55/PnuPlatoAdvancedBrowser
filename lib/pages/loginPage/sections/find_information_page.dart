import 'package:flutter/material.dart';
import 'package:pnu_plato_advanced_browser/common.dart';
import 'package:pnu_plato_advanced_browser/inappwebview_wrapper.dart';

class FindInformationPage extends StatelessWidget {
  final String target;
  final String url;

  const FindInformationPage({
    Key? key,
    required this.target,
  })  : url = target == 'id' ? CommonUrl.findIdUrl : CommonUrl.findPwUrl,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InappwebviewWrapper(
      '${target == 'id' ? '아이디' : '비밀번호'} 찾기',
      url,
      (controller, url) async {
        await controller.evaluateJavascript(
            source:
                "for (let e of document.getElementsByClassName('btn')) {  if (e.href.includes('close')) e.href = 'javascript:console.log(\\'ppab:close\\')' }");
      },
    );
  }
}
