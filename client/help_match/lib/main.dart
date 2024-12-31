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

  final userAuthCubit = UserAuthCubit(secureStorage: secureStorage);
  final dio = Dio();
  dio.interceptors.add(AppDioInterceptor(secureStorage, userAuthCubit, dio));

  final themeModeString = await secureStorage.read(key: "theme_mode");
  final initialThemeMode =
      (themeModeString == "dark") ? ThemeMode.dark : ThemeMode.light;
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => ThemeCubit(secureStorage)..emit(initialThemeMode),
      ),
      BlocProvider(
        create: (_) => userAuthCubit,
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
              if (state is UserAuthChecking) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Use the theme's primary color
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                );
              } else if (state is UserAuthIsLoggedIn) {
                final currentUser = context.read<UserAuthCubit>().currentUser;
                if (currentUser != null) {
                  // print('Logged in as: ${currentUser.username}');
                }
                return const Scaffold(
                  body: Center(
                      child: Text('Welcome to the App!')), // Example content
                );
              } else if (state is UserAuthInitial) {
                return const OnBoardingScreen();
              } else if (state is UserAuthError) {
                // Handle error state
                return Scaffold(
                  body: Center(
                    child: Text(
                      'An error occurred. Please try again. ${state.message}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              } else {
                // Fallback for any unexpected states
                return const OnBoardingScreen();
              }
            },
          ),
        );
      },
    );
  }
}
