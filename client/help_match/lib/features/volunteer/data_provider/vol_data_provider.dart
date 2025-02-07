import 'package:dio/dio.dart';
import 'package:help_match/core/location.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';
import 'package:latlong2/latlong.dart';

class VolunteerDataProvider {
  final Dio dio;
  VolunteerDataProvider({required this.dio});
  Future<dynamic> fetchOrgs(SearchDto dto,String queryParams) async {
    try {
   
      //uncomment this for fetching the current location
      // LatLng loc = await LocationProvider.getCurrentLocation();
      // Map<String, dynamic> body = {
      //   "latitude": loc.latitude,
      //   "longitude": loc.longitude
      // };
      
Map<String, dynamic> body = {
        "latitude": 0.2,
        "longitude": 5.5
      };

      dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
      ));
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
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      } else {
        throw Exception('Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
