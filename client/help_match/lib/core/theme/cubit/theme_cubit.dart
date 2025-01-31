import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final FlutterSecureStorage secureStorage;
  ThemeCubit(this.secureStorage) : super(ThemeMode.light) {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    final themeMode = await secureStorage.read(key: "theme_mode");
    if (themeMode == null) {
      await secureStorage.write(key: 'theme_mode', value: 'light');
    }
    if (themeMode == "light") {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.dark);
    }
  }

  void themeChange() async {
    final currentTheme = await secureStorage.read(key: "theme_mode");
    if (currentTheme == "light") {
      await secureStorage.write(key: "theme_mode", value: "dark");
      emit(ThemeMode.dark);
    } else {
      await secureStorage.write(key: "theme_mode", value: "light");
      emit(ThemeMode.light);
    }
  }
}
