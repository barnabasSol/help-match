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
      await secureStorage.deleteAll();
      emit(UserAuthInitial());
    } catch (e) {
      emit(UserAuthError('An error occurred during logout: ${e.toString()}'));
    }
  }

  late CurrentUser currentUser;

  Future<void> isUserAuthenticated() async {
    emit(UserAuthChecking());
    try {
      final accessToken = await secureStorage.read(key: 'access_token');
      if (accessToken == null || accessToken.isEmpty) {
        emit(UserAuthInitial());
        return;
      }
      currentUser = CurrentUser.fromToken(accessToken);

      await secureStorage.write(key: 'username', value: currentUser.username);
      await secureStorage.write(key: 'userId', value: currentUser.sub);

      emit(UserAuthIsLoggedIn(currentUser));
    } catch (e) {
      emit(UserAuthError(
        'An error occurred during authentication: ${e.toString()}',
      ));
    }
  }
}
