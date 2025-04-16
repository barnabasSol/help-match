import 'package:help_match/features/volunteer/dto/org_dto.dart';
import 'package:hive_ce/hive.dart';

class VolLocalProvider {
  final Box<OrgDto> _orgBox = Hive.box<OrgDto>('orgsBox');

  Future<void> addOrUpdateOrg(OrgDto org) async {
    if (org.id != null) {
      await _orgBox.put(org.id, org);
    }
  }

  OrgDto? getOrg(String id) {
    return _orgBox.get(id);
  }

  Future<void> deleteOrg(String orgId) async {
    await _orgBox.delete(orgId);
  }

  List<OrgDto> getAllOrgs() {
    return _orgBox.values.toList();
  }

  Future<void> clearAllOrgs() async {
    await _orgBox.clear();
  }

  bool hasOrg(String id) {
    return _orgBox.containsKey(id);
  }
}
