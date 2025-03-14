// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';
 
@immutable
sealed class ProfileEvent {}


class UpdateProfilePressed extends ProfileEvent {
  final VolProfileDto dto;

  UpdateProfilePressed({required this.dto});

}

class ProfileInfoFetched extends ProfileEvent {
  final String userId;
  ProfileInfoFetched(
    this.userId,
  );
}
