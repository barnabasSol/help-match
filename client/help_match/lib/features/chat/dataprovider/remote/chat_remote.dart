import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:help_match/core/secrets/secrets.dart';

class ChatRemoteDataProvider {
  final Dio _dio;

  ChatRemoteDataProvider({required Dio dio}) : _dio = dio;

  Future<dynamic> fetchRooms() async {
    try {
      final response = await _dio.get('${Secrets.LOCAL_DOMAIN}/v1/chat/rooms');
      if (response.statusCode == 200) {
        return response.data;
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

  Future<String> getMessages(String roomId) async {
    try {
      final response =
          await _dio.get('${Secrets.DOMAIN}/v1/chat/messages/$roomId');
      if (response.statusCode == 200) {
        return jsonEncode(response.data);
      } else {
        throw Exception('Failed to get messages: ${response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
