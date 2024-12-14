import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  DioInterceptor(this._secureStorage);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    var token = await _secureStorage.read(key: 'access_token');
    options.headers = <String, String>{"Authorization": "Bearer $token"};
    options.sendTimeout = const Duration(seconds: 5);
    options.receiveTimeout = const Duration(seconds: 5);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    if (response.statusCode == HttpStatus.unauthorized) {}
    if (handler.isCompleted) {}
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (handler.isCompleted) {}
  }
}
