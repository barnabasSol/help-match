import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/volunteer/dto/org_dto.dart';
import 'package:help_match/features/volunteer/dto/search_dto.dart';
import 'package:help_match/features/volunteer/repository/volunteer_repository.dart';

class LoadMoreCubit extends Cubit<List<OrgDto>> {
  final VolunteerRepository _volunteerRepository;
  LoadMoreCubit({
    required volunteerRepository,
  }):_volunteerRepository=volunteerRepository,super([]);

  Future<void> fetchMore(SearchDto dto) async {
    try {
      final List<OrgDto> orgs = await _volunteerRepository.getOrgs(dto);
      emit(orgs);
    } catch (e) {
      emit([]);
    }
  }
}
