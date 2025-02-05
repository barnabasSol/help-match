import 'package:dio/dio.dart';
import 'package:help_match/core/secrets/secrets.dart';

class AuthDataProvider {
  final Dio _dio;
  AuthDataProvider({required dio}) : _dio = dio;
  Future<dynamic> login(Map<String, dynamic> json) async {
    try {
      final response =
          await _dio.post('${Secrets.DOMAIN}/v1/auth/login', data: json);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to log user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      } else {
        throw Exception('Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<dynamic> signUp(Map<String, dynamic> json) async {
    try {
      final response =
          await _dio.post('${Secrets.DOMAIN}/v1/auth/signup', data: json);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to signup user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      } else {
        throw Exception('Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
