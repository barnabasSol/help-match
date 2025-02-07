import 'package:dio/dio.dart';
import 'package:help_match/features/volunteer/data_provider/vol_data_provider.dart';
import 'package:help_match/features/volunteer/dto/org_card_dto.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';

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


    try {
      final response = await dataProvider.fetchOrgs(sto,queryParams);
      final dynamic data = response["data"]["result"];
      if (data is List) {
        List<OrgCardDto> orgs = data.map((o) => OrgCardDto.fromJson(o)).toList();
        return orgs;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}
