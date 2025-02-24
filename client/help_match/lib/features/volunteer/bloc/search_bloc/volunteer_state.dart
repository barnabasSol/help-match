part of 'volunteer_bloc.dart';

@immutable
sealed class VolunteerState {}

final class VolunteerInitial extends VolunteerState {}

final class OrgsLoading extends VolunteerState {}

final class OrgsFetchedSuccessfully extends VolunteerState {
  final List<OrgCardDto> organizations;

  OrgsFetchedSuccessfully({required this.organizations});
}

final class OrgsFetchedFailed extends VolunteerState {
  final String error;

  OrgsFetchedFailed({required this.error});
}

