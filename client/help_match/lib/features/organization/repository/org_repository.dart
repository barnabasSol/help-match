import 'package:help_match/features/organization/data_provider/org_remote.dart';
import 'package:help_match/features/organization/dto/applicant_dto.dart';
import 'package:help_match/features/organization/dto/update_status_dto.dart';

class OrgRepository {
  final OrgDataProvider _dataProvider;
  OrgRepository(this._dataProvider);
  Future<List<ApplicantDto>> getApplicants() async {
    try {
      final response = await _dataProvider.getJobApplicants();

      final dynamic data = response['data'];

      if (data is List) {
        final List<ApplicantDto> applicants =
            data.map((json) => ApplicantDto.fromMap(json)).toList();
        return applicants;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to parse applicants: $e');
    }
  }

  Future updateStatus(UpdateStatusDto dto) async {
    try {
      //modify the dto by adding the user id
      // final response = await _dataProvider.getUserId(dto.username);
      // final id = response["data"]["id"];
      // dto.userId = id;
      await _dataProvider.updateStatus(dto.toJson());
    } catch (e) {
      throw Exception("Unable to update status!");
    }
  }
}
