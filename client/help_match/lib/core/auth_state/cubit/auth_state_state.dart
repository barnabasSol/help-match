part of 'auth_state_cubit.dart';

@immutable
sealed class AuthStateState {}

final class AuthStateInitial extends AuthStateState {}

class AuthState extends AuthStateState {
  final bool isAuthenticated;

  AuthState(this.isAuthenticated);
}
