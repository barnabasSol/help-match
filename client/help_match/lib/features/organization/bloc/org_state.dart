part of 'org_bloc.dart';

sealed class OrgState {}

class OrgInitial extends OrgState {}

class FetchSuccessful extends OrgState {
  List<ApplicantDto> applicants;
  FetchSuccessful(this.applicants);
}

class FetchLoading extends OrgState {}

class FetchFailed extends OrgState {
  String error;
  FetchFailed(this.error);
}

class OrgJobAddFailure extends OrgState {
  String error;
  OrgJobAddFailure(this.error);
}

class OrgJobAddSuccess extends OrgState {}

class OrgJobAddLoading extends OrgState {}
