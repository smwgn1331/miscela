import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../common/logger.dart';
import '../config/http.dart';
import '../core.dart';
import '../widgets/button.dart';
import 'navigation.dart';
import 'storage.dart';

class Http {
  late Dio _http;
  final BaseOptions _options = BaseOptions(
      baseUrl: Miscela.svc<HttpConfig>().httpBaseUrl,
      contentType: "Application/json",
      responseType: ResponseType.json,
      connectTimeout: Miscela.svc<HttpConfig>().connectTimeout,
      receiveTimeout: Miscela.svc<HttpConfig>().receiveTimeout);

  Http.guest() {
    _http = Dio(_options);
    _http.interceptors.add(InterceptorsWrapper(
        onRequest: onRequestGuestIntercept,
        onResponse: onResponseIntercept,
        onError: onErrorIntercept));
  }

  Http() {
    _http = Dio(_options);
    _http.interceptors.add(InterceptorsWrapper(
        onRequest: onRequestIntercept,
        onResponse: onResponseIntercept,
        onError: onErrorIntercept));
  }

  onResponseIntercept(response, handler) {
    MxLog.info("data: ${response.data}", name: "Http::onResponse");
    return handler.next(response);
  }

  onRequestGuestIntercept(RequestOptions options, handler) async {
    MxLog.info("url: ${options.baseUrl}", name: "Http::onRequest");
    MxLog.info("data: ${options.data}", name: "Http::onRequest");
    return handler.next(options);
  }

  onRequestIntercept(options, handler) async {
    String token = await Miscela.svc<Storage>().get("token");
    options.headers["Authorization"] = "Bearer $token";

    MxLog.info("url: ${options.baseUrl}", name: "Http::onRequest");
    MxLog.info("headers: ${options.headers}", name: "Http::onRequest");
    MxLog.info("data: ${options.data}", name: "Http::onRequest");
    return handler.next(options);
  }

  onErrorIntercept(DioError e, handler) async {
    if (e.type == DioErrorType.connectTimeout) {
      Miscela.svc<Navigation>().showModal(
          title: const Text("Oops."),
          content: Text("${e.requestOptions.uri} Tidak bisa diakses."));
    } else if (e.type == DioErrorType.receiveTimeout) {
      Miscela.svc<Navigation>().showModal(
          title: const Text("Oops."),
          content: const Text("Batas waktu habis."));
    } else if (e.type == DioErrorType.response) {
      if (e.response?.statusCode == 401) {
        await Miscela.svc<Storage>().put("token", null);
        Miscela.svc<Navigation>().showModal(
            title: const Text("Oops."),
            content: const Text("Silahkan login kembali."),
            actions: [
              MxButton(
                  label: 'Ok',
                  onPressed: () => Miscela.svc<Navigation>().back())
            ]).then(
            (value) => Miscela.svc<Navigation>().replaceAllWith('/login'));
      }
    }
    return handler.next(e);
  }

  Dio get http => _http;
}
