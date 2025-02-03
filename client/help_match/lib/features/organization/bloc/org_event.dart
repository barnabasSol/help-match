part of 'org_bloc.dart';

sealed class OrgEvent {}

class ApplicantsFetched extends OrgEvent {
  String jobId;
  ApplicantsFetched(this.jobId);
}

class ApplicantAccepted extends OrgEvent {}

class ApplicantRejected extends OrgEvent {}
