import 'package:help_match/features/organization/data_provider/org_remote.dart';
import 'package:help_match/features/organization/dto/applicant_dto.dart';

class OrgRepository {
  final OrgDataProvider _dataProvider;
  OrgRepository(this._dataProvider);
  Future<List<ApplicantDto>> getApplicants(String job_id) async {
    try {
      final response = await _dataProvider.getJobApplicants( job_id);

      final dynamic data = response['data'];

      if (data is List) {
        final List<ApplicantDto> applicants =
            data.map((json) => ApplicantDto.fromJson(json)).toList();
        return applicants;
      } else {
        throw Exception(
            'Invalid response format: Expected a list of applicants in the "data" field');
      }
    } catch (e) {
      throw Exception('Failed to parse applicants: $e');
    }
  }
}
