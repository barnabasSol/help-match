import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/features/Auth/dto/login_dto.dart';
import 'package:help_match/features/Auth/dto/signup_dto.dart';
import 'package:help_match/features/Auth/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  FlutterSecureStorage secureStorage;

  AuthBloc({required this.authRepository, required this.secureStorage})
      : super(AuthInitial()) {
    on<AuthLoginPressed>((event, emit) async {
      emit(AuthLoginLoading());
      try {
        final tokens = await authRepository.signIn(event.loginDto);
        await secureStorage.write(key: 'access_token', value: tokens['access_token']);
        await secureStorage.write(key: 'refresh_token', value: tokens['refresh_token']);
        emit(AuthLoginSuccess());
      } catch (e) {
      emit(AuthLoginFailure(e is Exception ? (e as dynamic).message ?? e.toString() : e.toString()));
      }
    });
    on<UserAuthSignupPressed>((event, emit) async {
      emit(AuthSignupLoading());
      try {
        final tokens = await authRepository.signUpUser(event._dto);
        await secureStorage.write(key: 'access_token', value: tokens['access_token']);
        await secureStorage.write(key: 'refresh_token', value: tokens['refresh_token']);

        emit(AuthSignupSuccess());
      } catch (e) {
           emit(AuthLoginFailure(e is Exception ? (e as dynamic).message ?? e.toString() : e.toString()));

      }
    });
    on<OrgAuthSignupPressed>((event, emit) async {
      emit(AuthSignupLoading());
      try {
        final tokens = await authRepository.signUpOrg(event._dto);
        await secureStorage.write(key: 'access_token', value: tokens['access_token']);
        await secureStorage.write(key: 'refresh_token', value: tokens['refresh_token']);
        emit(AuthSignupSuccess());
      } catch (e) {
           emit(AuthLoginFailure(e is Exception ? (e as dynamic).message ?? e.toString() : e.toString()));

      }
    });
  }
}
