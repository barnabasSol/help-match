part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoginLoading extends AuthState {}

final class AuthLoginFailure extends AuthState {
  final String error;
  AuthLoginFailure(this.error);
}

final class AuthLoginSuccess extends AuthState {
}

final class AuthSignupLoading extends AuthState {}

final class AuthSignupFailure extends AuthState {
   final String error;
  AuthSignupFailure(this.error);
}

final class AuthSignupSuccess extends AuthState {}
