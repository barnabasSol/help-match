import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/organization/dto/applicant_dto.dart';
import 'package:help_match/features/organization/repository/org_repository.dart';
part './org_event.dart';
part './org_state.dart';

class OrgBloc extends Bloc<OrgEvent, OrgState> {
  OrgRepository orgRepo;
  OrgBloc(this.orgRepo) : super(OrgInitial()) {
    on<ApplicantsFetched>(_fetchApplicants);
  }
  Future<void> _fetchApplicants(
      ApplicantsFetched event, Emitter<OrgState> emit) async {
    emit(FetchLoading());
    try {
      final applicants = await orgRepo.getApplicants();
      emit(FetchSuccessful(applicants));
    } catch (e) {
      emit(FetchFailed(e.toString()));
      //throw (e.toString());
    }
  }
}
