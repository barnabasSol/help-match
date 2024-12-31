import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/core/current_user/user_entity.dart';

part 'user_auth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  final FlutterSecureStorage secureStorage;

  UserAuthCubit({required this.secureStorage}) : super(UserAuthInitial());

  Future<void> kickOut() async {
    try {
      await secureStorage.delete(key: 'access_token');
      await secureStorage.delete(key: 'refresh_token');
      emit(UserAuthInitial());
    } catch (e) {
      emit(UserAuthError('An error occurred during logout: ${e.toString()}'));
    }
  }

  Future<void> isUserAuthenticated() async {
    emit(UserAuthChecking());
    try {
      final accessToken = await secureStorage.read(key: 'access_token');
      if (accessToken == null || accessToken.isEmpty) {
        emit(UserAuthInitial());
        return;
      }

      final CurrentUser user = CurrentUser.fromToken(accessToken);
      if (user.isExpired()) {
        emit(UserAuthInitial());
        return;
      }

      emit(UserAuthIsLoggedIn(user));
    } catch (e) {
      emit(UserAuthError(
        'An error occurred during authentication: ${e.toString()}',
      ));
    }
  }

  CurrentUser? get currentUser {
    if (state is UserAuthIsLoggedIn) {
      return (state as UserAuthIsLoggedIn).currentUser;
    }
    return null;
  }
}
