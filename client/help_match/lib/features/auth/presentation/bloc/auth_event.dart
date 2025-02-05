part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class UserAuthSignupPressed extends AuthEvent {
  final UserSignUpDto _dto;
  UserAuthSignupPressed({required dto}):_dto=dto;
}
final class OrgAuthSignupPressed extends AuthEvent {
  final OrgSignUpDto _dto;
  OrgAuthSignupPressed({required dto}):_dto=dto;
}
final class AuthLoginPressed extends AuthEvent {
  final LoginDTO loginDto;
  AuthLoginPressed(this.loginDto);
}

final class AuthLogoutPressed extends AuthEvent {}
