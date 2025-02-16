// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'volunteer_bloc.dart';

@immutable
sealed class VolunteerEvent {}

class SearchPressed extends VolunteerEvent {
  final SearchDto dto;

  SearchPressed({required this.dto});
}

class InitialFetch extends VolunteerEvent {}

class UpdateProfilePressed extends VolunteerEvent {
  final VolProfileDto dto;

  UpdateProfilePressed({required this.dto});

}

class ProfileInfoFetched extends VolunteerEvent {
  final String userId;
  ProfileInfoFetched(
    this.userId,
  );
}
