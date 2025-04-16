import 'package:help_match/features/volunteer/data_provider/vol_data_provider.dart';
import 'package:help_match/features/volunteer/data_provider/vol_local_provider.dart';
import 'package:help_match/features/volunteer/dto/org_dto.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';
import 'package:help_match/features/volunteer/dto/vol_profile_dto.dart';

class VolunteerRepository {
  final VolunteerDataProvider dataProvider;
  final VolLocalProvider localProvider;
  VolunteerRepository({required this.dataProvider,required this.localProvider});

  Future<List<OrgDto>> getOrgs(SearchDto sto) async {
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
        List<OrgDto> orgs = data.map((o) => OrgDto.fromJson(o)).toList();
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

  Future<OrgDto> fetchOrgInfo(String org_id) async {
    try {
      OrgDto org;
var localOrg = localProvider.getOrg(org_id);
      if (localOrg != null) {
        return localOrg;
      }

      var data = await dataProvider.fetchOrg(org_id);
      var orgInfo = data['data'];
      orgInfo['org_id']= org_id; 
      org = OrgDto.fromMap(orgInfo);
      await localProvider.addOrUpdateOrg(org);
      return org;
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
