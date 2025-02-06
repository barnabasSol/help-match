import 'package:dio/dio.dart';
import 'package:help_match/core/secrets/secrets.dart';

class OrgDataProvider {
  final Dio _dio;
  OrgDataProvider({required dio}) : _dio = dio;
  Future<dynamic> getJobApplicants() async {
    try {
      final response = await _dio.get('${Secrets.DOMAIN}/v1/job/applicants/');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get applicants: ${response.statusMessage}');
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

  Future<void> updateStatus(Map<String,dynamic> json) async {
    try {
      final response = await _dio.patch('${Secrets.DOMAIN}/v1/job/status',data: json);
      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to update status: ${response.statusMessage}');
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

  Future<dynamic> getUserId(String name) async {
    try {
      final response =
          await _dio.get('${Secrets.DOMAIN}/v1/user-by?username=$name');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch user: ${response.statusMessage}');
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
