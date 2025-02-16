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

final class ProfileInfoFetchSuccess extends VolunteerState {
  final User user;

  ProfileInfoFetchSuccess({required this.user});

}
final class ProfileInfoFetchFailure extends VolunteerState {
  final String error;

  ProfileInfoFetchFailure({required this.error});

}
final class ProfileUpdateSuccess extends VolunteerState {}

final class ProfileUpdateFailure extends VolunteerState {
  final String error;

  ProfileUpdateFailure({required this.error});
}
