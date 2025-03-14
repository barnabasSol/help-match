import 'package:help_match/features/organization/dto/job_add_dto.dart';
import 'package:help_match/features/volunteer/data_provider/vol_data_provider.dart';
import 'package:help_match/features/volunteer/dto/job_view_dto.dart';
import 'package:help_match/features/volunteer/dto/org_card_dto.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';
import 'package:help_match/features/volunteer/dto/vol_profile_dto.dart';
import 'package:help_match/features/volunteer/presentation/widgets/job_card.dart';

class VolunteerRepository {
  final VolunteerDataProvider dataProvider;
  VolunteerRepository({required this.dataProvider});

  Future<List<OrgCardDto>> getOrgs(SearchDto sto) async {
    String queryParams = "";
    if (sto.org_name.isNotEmpty && sto.org_type.isNotEmpty) {
      queryParams = "org_name=${sto.org_name}&org_type=${sto.org_type}";
    } else if (sto.org_name.isEmpty && sto.org_type.isEmpty) {
    } else {
      queryParams = sto.org_name.isNotEmpty
          ? "org_name=${sto.org_name}"
          : "org_type=${sto.org_type}";
    }
    if (sto.page > 0) queryParams += "&page=${sto.page}";
    try {
      final response = await dataProvider.fetchOrgs(sto, queryParams);
      final dynamic data = response["data"]["result"];
      if (data is List) {
        List<OrgCardDto> orgs =
            data.map((o) => OrgCardDto.fromJson(o)).toList();
        return orgs;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserData(VolProfileDto dto) async {
    try {
      if (dto.img != null) {
        await dataProvider.upload_image(dto.img!);
      }
      await dataProvider.updateUser(dto.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<JobViewDto>> getJobs(String org_id) async {
    try {
      List<JobViewDto> jobs = [];
      var data = await dataProvider.fetchJobs(org_id);
      if (data is List) {
        jobs = data.map((json) => JobViewDto.fromJson(json)).toList();
      }
      return jobs;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> applyJob(String job_id) async {
    try {
      await dataProvider.applyJob(job_id);
    } catch (e) {
      rethrow;
    }
  }
}
