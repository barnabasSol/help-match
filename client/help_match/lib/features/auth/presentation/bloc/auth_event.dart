part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignupPressed extends AuthEvent {}

final class AuthLoginPressed extends AuthEvent {
  final LoginDto loginDto;
  AuthLoginPressed(this.loginDto);
}

final class AuthLogoutPressed extends AuthEvent {}
