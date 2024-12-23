import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/core/current_user/user_entity.dart';

part 'user_auth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  final FlutterSecureStorage secureStorage;
  UserAuthCubit({required this.secureStorage}) : super(UserAuthInitial());

  Future<void> isUserAuthenticated() async {
    try {
      final accessToken = await secureStorage.read(key: 'access_token');
      if (accessToken == null || accessToken.isEmpty) {
        return emit(UserAuthInitial());
      }

      // Ensure CurrentUser.fromToken handles null or invalid tokens gracefully
      final CurrentUser user = CurrentUser.fromToken(accessToken);
      if (user.isExpired()) {
        return emit(UserAuthInitial());
      }

      return emit(UserAuthIsLoggedIn(user));
    } catch (e) {
      // Handle any unexpected errors
      emit(UserAuthError('An error occurred: ${e.toString()}'));
    }
  }
}
