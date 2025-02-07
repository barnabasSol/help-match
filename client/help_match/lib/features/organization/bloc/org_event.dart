part of 'org_bloc.dart';

sealed class OrgEvent {}

class ApplicantsFetched extends OrgEvent {}

class OrgJobAdded extends OrgEvent {
  final JobDto jobDto;
  OrgJobAdded(this.jobDto);
}
