import 'package:bloc/bloc.dart';
import 'package:help_match/features/volunteer/dto/org_dto.dart';
import 'package:help_match/features/volunteer/repository/volunteer_repository.dart';
import 'package:meta/meta.dart';

part 'org_event.dart';
part 'org_state.dart';

class OrganizationBloc extends Bloc<OrgEvent, OrgState> {
  final VolunteerRepository _volunteerRepository;
  OrganizationBloc({required volunteerRepository})
      : _volunteerRepository = volunteerRepository,
        super(OrgInitial()) {
    on<FetchedOrg>((event, emit) async {
      try {
        emit(OrgLoading());
        final OrgDto org =
            await _volunteerRepository.fetchOrgInfo(event.org_id);
        emit(OrgFetchedSuccessfully(org: org));
      } catch (e) {
        emit(OrgFetchFailed(error: e.toString()));
      }
    });
    
  }
}
