import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/core/secrets/secrets.dart';

class AppDioInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final UserAuthCubit _authCubit;
  final Dio _dio;

  AppDioInterceptor(this._secureStorage, this._authCubit, this._dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.path.contains('login') && !options.path.contains('signup')) {
      var token = await _secureStorage.read(key: 'access_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    options.sendTimeout = const Duration(seconds: 5);
    options.receiveTimeout = const Duration(seconds: 5);
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          await _secureStorage.write(key: 'access_token', value: newToken);
          final newRequest = err.requestOptions;
          newRequest.headers['Authorization'] = 'Bearer $newToken';
          final response = await _dio.fetch(newRequest);
          return handler.resolve(response);
        } else {
          _authCubit.kickOut();
        }
      } catch (e) {
        _authCubit.kickOut();
      }
    }
    super.onError(err, handler);
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) return null;

      final username = await _secureStorage.read(key: 'username');
      final response = await _dio.post(
        '${Secrets.DOMAIN}/auth/renew',
        data: {
          'username': username,
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return response.data['access_token'];
      }
    } catch (_) {
      // Log the error or handle it as needed
    }
    return null;
  }
}
