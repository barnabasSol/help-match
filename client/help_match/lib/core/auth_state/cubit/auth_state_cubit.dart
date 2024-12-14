import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_state_state.dart';

class AuthStateCubit extends Cubit<AuthStateState> {
  final FlutterSecureStorage _secureStorage;

  AuthStateCubit(this._secureStorage) : super(AuthState(false)) {
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    String? token = await _secureStorage.read(key: 'token');
    emit(AuthState(token != null));
  }
}
