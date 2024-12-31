part of 'user_auth_cubit.dart';

@immutable
sealed class UserAuthState {}

final class UserAuthInitial extends UserAuthState {}

final class UserAuthIsLoggedIn extends UserAuthState {
  final CurrentUser currentUser;
  UserAuthIsLoggedIn(this.currentUser);
}

class UserAuthError extends UserAuthState {
  final String message;
  UserAuthError(this.message);
}

class UserAuthChecking extends UserAuthState {}
