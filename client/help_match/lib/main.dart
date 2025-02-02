import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/core/interceptor/interceptor.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/core/theme/colors.dart';
import 'package:help_match/core/theme/cubit/theme_cubit.dart';
import 'package:help_match/core/ws_manager/ws_manager.dart';
import 'package:help_match/features/auth/presentation/pages/SignupO1.dart';
import 'package:help_match/features/auth/presentation/pages/SignupO2.dart';
import 'package:help_match/features/auth/presentation/pages/SignupV1.dart';
import 'package:help_match/features/auth/presentation/pages/SignupV2.dart';
import 'package:help_match/features/auth/presentation/pages/SignupV3.dart';
import 'package:help_match/features/auth/presentation/pages/login.dart';
import 'package:help_match/features/auth/presentation/pages/signup.dart';
import 'package:help_match/features/chat/dataprovider/remote/chat_remote.dart';
import 'package:help_match/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:help_match/features/chat/repository/chat_repository.dart';
import 'package:help_match/features/onboarding/screen/onboarding_screen.dart';
import 'package:help_match/features/volunteer/presentation/screens/volunteer_screen.dart';
import 'package:help_match/shared/widgets/loading_indicator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  final userAuthCubit = UserAuthCubit(secureStorage: secureStorage);

  await secureStorage.write(
      key: 'access_token',
      value:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImRhZyIsInJvbGUiOiJ1c2VyIiwiaXNzIjoiaHR0cHM6Ly9obS5iYXJuZXktaG9zdC5zaXRlIiwic3ViIjoiYzUzMjZiMWUtZGYxMi0xMWVmLWJhNjEtZGI2NzI4OGI0MTNlIiwiYXVkIjpbImNvbS5iYXJuZXktaG9zdC5obSJdLCJleHAiOjE3Mzg4NTA1MDksImlhdCI6MTczODI0NTcxOH0.OSdQymU4QJgE7fK0RemZFa0DngbVaO4C4YImf7tVMmQ');

  final dio = Dio();
  dio.interceptors.add(AppDioInterceptor(secureStorage, userAuthCubit, dio));

  try {
    final res = await dio.get('${Secrets.LOCAL_DOMAIN}/v1/otp');

    final data = jsonDecode(res.data);

    final otp = data['otp'];

    final wsManager = WsManager(secureStorage);
    await wsManager.connect("${Secrets.LOCAL_DOMAIN}/v1/ws", otp);
  } catch (e) {
    print('Error occurred:');
    print(e);
  }

  final themeModeString = await secureStorage.read(key: "theme_mode");
  final initialThemeMode =
      (themeModeString == "dark") ? ThemeMode.dark : ThemeMode.light;
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ChatRemoteDataProvider>(
          create: (_) => ChatRemoteDataProvider(dio: dio),
        ),
        RepositoryProvider<ChatRepository>(
          create: (context) => ChatRepository(
            context.read<ChatRemoteDataProvider>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    ThemeCubit(secureStorage)..emit(initialThemeMode),
              ),
              BlocProvider(
                create: (_) => userAuthCubit,
              ),
              BlocProvider(
                create: (_) => ChatBloc(context.read<ChatRepository>()),
              ),
            ],
            child: const MyApp(),
          );
        },
      ),
    ),
  );
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
          //  route navigation for the pages
          routes: {
            '/login': (context) => Login(),

            '/signup': (context) => Signup(),

            '/signupv1': (context) => Signupv1(),
            '/signupv2': (context) => Signupv2(),
            '/signupv3': (context) => Signupv3(),
            
            '/signupo1': (context) => Signupo1(),
            '/signupo2': (context) => Signupo2(),
         },

          title: 'HelpMatch',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state,

          // home:  SignUp(),
          home: BlocBuilder<UserAuthCubit, UserAuthState>(
            builder: (context, state) {
              if (state is UserAuthChecking) {
                return const LoadingIndicator();
              } else if (state is UserAuthIsLoggedIn) {
                final currentUser = context.read<UserAuthCubit>().currentUser;
                if (currentUser!.role == "user") {
                  // return const VolunteerScreen();
                  return Signup();
                }
                return const Scaffold();
              } else if (state is UserAuthInitial) {
                return const OnBoardingScreen();
              } else if (state is UserAuthError) {
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
