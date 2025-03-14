import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/core/location.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';
import 'package:latlong2/latlong.dart';

class VolunteerDataProvider {
  final FlutterSecureStorage _secureStorage;
  final Dio dio;

  VolunteerDataProvider({required this.dio, required sec})
      : _secureStorage = sec;
  Future<dynamic> fetchOrgs(SearchDto dto, String queryParams) async {
    queryParams += "&page_size=4";
    try {
      LatLng loc = await LocationProvider.getCurrentLocation();
      Map<String, dynamic> body = {
        "latitude": loc.latitude,
        "longitude": loc.longitude
      };
      final response = await dio.post(
        '${Secrets.DOMAIN}/v1/org?$queryParams',
        data: body,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch orgs: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      } else {
        throw Exception('Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<dynamic> updateUser(Map<String, dynamic> json) async {
    try {
      final response = await dio.patch(
        '${Secrets.DOMAIN}/v1/user',
        data: json,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to update user info: ${response.statusMessage}');
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

  Future<dynamic> upload_image(Uint8List img) async {
    try {
      var form_data = FormData.fromMap(
          {"the_file": MultipartFile.fromBytes(img, filename: "uploaded.jpg")});
      var token = await _secureStorage.read(key: 'access_token');
      final response = await dio.patch(
          '${Secrets.DOMAIN}/v1/upload?type=profile',
          data: form_data,
          options: Options(headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token"
          }));
      if (response.statusCode == 200) {
        // print("Successfully uploaded");
        return response.data;
      } else {
        throw Exception(
            'Failed to upload the image: ${response.statusMessage}');
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

  Future<dynamic> fetchJobs(String org_id)async {
    try{
         final response = await dio.get(
          '${Secrets.DOMAIN}/v1/org/$org_id',
           );
      if (response.statusCode == 200) { 
        return response.data["data"]["jobs"];
      } else {
        throw Exception(
            'Failed to fetch jobs: ${response.statusMessage}');
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

Future<dynamic> applyJob(String job_id)async {
    try{
         final response = await dio.post(
          '${Secrets.DOMAIN}/v1/job/apply/$job_id',
           );
      if (response.statusCode == 200) { 
        return response.data["message"];
      } else {
        throw Exception(
            'Failed to apply job: ${response.statusMessage}');
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

