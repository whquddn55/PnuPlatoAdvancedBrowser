import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';

Future<Dio.Response?> request(String url, {Dio.Options? options, Function? callback}) async {
  Dio.Response? response;
  int retry = 0;
  while (retry < 5) {
    try {
      response = await Dio.Dio().get(url,
          options: options
      );
      if (parse(response.data).children[0].attributes['class'] == 'html_login') {
        retry++;
        if (callback != null) {
          await callback();
        }
      }
      else {
        break;
      }
    }
    on Dio.DioError catch(e, _) {
      retry++;
    }
  }
  return response;
}

void showBugReport(String msg) {
  var _controller = TextEditingController();
  Get.defaultDialog(
    title: '버그리포트',
    barrierDismissible: false,
    content: Column(
      children: [
        SizedBox(
          width: Get.width,
          height: 300,
          child: TextFormField(
            maxLines: null,
            minLines: null,
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: '상세한 상황을 설명해주세요.\n(ex: A를 하려하다가 B버튼을 누르니 C에러가 떴습니다.)',
            ),
            autofocus: true,
            expands: true,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('작성하신 내용과 내부 버그 정보를 포함하여 서버에 전송하게 됩니다.'),
        )
      ],
    ),
    cancel: TextButton(
      child: Text('취소', style: TextStyle(color: Get.theme.disabledColor)),
      onPressed: () => Get.back(),
    ),
    confirm: TextButton(
      child: const Text('전송'),
      onPressed: () {
        /* TODO: 버그 전송 */
        print(_controller.text);
        Get.back();
      },
    )
  );
}