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
import 'package:help_match/features/chat/dataprovider/remote/chat_remote.dart';
import 'package:help_match/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:help_match/features/chat/repository/chat_repository.dart';
import 'package:help_match/features/onboarding/screen/onboarding_screen.dart';
import 'package:help_match/features/organization/bloc/org_bloc.dart';
import 'package:help_match/features/organization/data_provider/org_remote.dart';
import 'package:help_match/features/organization/presentation/pages/screen.dart';
import 'package:help_match/features/organization/repository/org_repository.dart';
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
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImRhZ20iLCJyb2xlIjoidXNlciIsImlzcyI6Imh0dHBzOi8vaG0uYmFybmV5LWhvc3Quc2l0ZSIsInN1YiI6IjJiNGEyYWRlLWUwNzgtMTFlZi05OWJkLWQzNmQyOTU0MjdlNyIsImF1ZCI6WyJjb20uYmFybmV5LWhvc3QuaG0iXSwiZXhwIjoxNzM5MDExNTk5LCJpYXQiOjE3Mzg0MDkwOTd9.VNs4F4iUQ4KuGxBU3XPK1FWaWnpFtIYFnDkWwyOd_2k");

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
        RepositoryProvider(create: (context) => OrgDataProvider(dio: dio)
        ),
        RepositoryProvider(create: (context)=>OrgRepository(context.read<OrgDataProvider>()))
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => OrgBloc(context.read<OrgRepository>())),
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
          title: 'HelpMatch',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state,
          home: BlocBuilder<UserAuthCubit, UserAuthState>(
            builder: (context, state) {
              if (state is UserAuthChecking) {
                return const LoadingIndicator();
              } else if (state is UserAuthIsLoggedIn) {
                final currentUser = context.read<UserAuthCubit>().currentUser;
                if (currentUser!.role == "user") {
                  return const OrgScreen();
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
