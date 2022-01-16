import 'package:dio/dio.dart' as Dio;
import 'package:html/parser.dart';

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