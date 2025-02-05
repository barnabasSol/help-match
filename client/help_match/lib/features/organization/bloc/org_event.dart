part of 'org_bloc.dart';

sealed class OrgEvent {}

class ApplicantsFetched extends OrgEvent {
   ApplicantsFetched();
}

class ApplicantAccepted extends OrgEvent {}

class ApplicantRejected extends OrgEvent {}
