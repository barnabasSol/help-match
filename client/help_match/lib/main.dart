import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/core/interceptor/interceptor.dart';
import 'package:help_match/core/theme/colors.dart';
import 'package:help_match/core/theme/cubit/theme_cubit.dart';
import 'package:help_match/features/onboarding/screen/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  final dio = Dio();
  dio.interceptors.add(AppDioInterceptor(secureStorage));

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => ThemeCubit(secureStorage),
      ),
      BlocProvider(
        create: (_) => UserAuthCubit(secureStorage: secureStorage),
      ),
    ],
    child: const MyApp(),
  ));
}

//ROOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOT
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<UserAuthCubit>().isUserAuthenticated();
    context.read<ThemeCubit>().loadTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Helpmatch',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state,
          home: BlocBuilder<UserAuthCubit, UserAuthState>(
            builder: (context, state) {
              if (state is UserAuthIsLoggedIn) {
                return const Scaffold();
              } else if (state is UserAuthInitial) {
                return const OnBoardingScreen();
              } else {
                return const OnBoardingScreen();
              }
            },
          ),
        );
      },
    );
  }
}
