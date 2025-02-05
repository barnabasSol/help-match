import 'package:dio/dio.dart';
import 'package:help_match/core/secrets/secrets.dart';

class NotificationProvider {
  final Dio dio;
  NotificationProvider({required this.dio});

  Future<dynamic> fetchVolunteerNotifications() async {
    try {
      final response =
          await dio.get('${Secrets.LOCAL_DOMAIN}/v1/notifications/volunteer');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to get notifications: ${response.statusMessage}');
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

  Future<dynamic> fetchOrgNotifications() async {
    try {
      final response = await dio
          .get('${Secrets.LOCAL_DOMAIN}/v1/notifications/organization');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
          'Failed to get notifications: ${response.statusMessage}',
        );
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
