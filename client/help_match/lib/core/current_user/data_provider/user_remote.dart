import 'package:dio/dio.dart';
import 'package:help_match/core/current_user/model/user_cache_model.dart';
import 'package:help_match/core/secrets/secrets.dart';

class UserInfoRemoteProvider {
  final Dio dio;

  UserInfoRemoteProvider(this.dio);

  Future<User?> fetchCurrentUser(String username) async {
    try {
      final response =
          await dio.get('${Secrets.APP_DOMAIN}/v1/user-by?user_id=$username');
      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to get rooms: ${response.statusMessage}');
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
