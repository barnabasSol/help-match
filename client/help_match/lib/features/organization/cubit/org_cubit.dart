import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/organization/cubit/org_applicant_state.dart';
import 'package:help_match/features/organization/dto/update_status_dto.dart';
import 'package:help_match/features/organization/repository/org_repository.dart';

class OrgCubit extends Cubit<ApplicantState> {
  final OrgRepository orgRepo;
  OrgCubit({required orgRepository}):orgRepo=orgRepository, super(InitialState());

  Future<void> applicantAccepted(UpdateStatusDto dto) async {
    try {
      await orgRepo.updateStatus(dto);
      emit(UpdateStatusSuccessful(status: "Accepted"));
      // emit(A)
    } catch (e) {
      emit(UpdateStatusFailed(e.toString()));
    }
  }

  Future<void> applicantRejected(UpdateStatusDto dto) async {
    try {
      await orgRepo.updateStatus(dto);
      emit(UpdateStatusSuccessful(status: "Rejected"));
    } catch (e) {
      emit(UpdateStatusFailed(e.toString()));
    }
  }
}
