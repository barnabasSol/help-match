
part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}


final class ProfileInfoFetchSuccess extends ProfileState {
  final User user;

  ProfileInfoFetchSuccess({required this.user});

}
final class ProfileInfoFetchFailure extends ProfileState {
  final String error;

  ProfileInfoFetchFailure({required this.error});

}
final class ProfileUpdateSuccess extends ProfileState {}

final class ProfileUpdateFailure extends ProfileState {
  final String error;

  ProfileUpdateFailure({required this.error});
}
