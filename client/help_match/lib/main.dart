import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/core/current_user/data_provider/local.dart';
import 'package:help_match/core/current_user/data_provider/user_remote.dart';
import 'package:help_match/core/current_user/repository/user_repo.dart';
import 'package:help_match/core/interceptor/interceptor.dart';
import 'package:help_match/core/local_storage/app_local.dart';
import 'package:help_match/core/theme/colors.dart';
import 'package:help_match/core/theme/cubit/theme_cubit.dart';
import 'package:help_match/core/ws_manager/cubit/websocket_cubit.dart';
import 'package:help_match/core/ws_manager/ws_manager.dart';
import 'package:help_match/features/chat/dataprovider/remote/chat_remote.dart';
import 'package:help_match/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:help_match/features/chat/presentation/bloc/rooms_bloc/rooms_bloc.dart';
import 'package:help_match/features/chat/repository/chat_repository.dart';
import 'package:help_match/features/notifications/data_provider/notif_provider.dart';
import 'package:help_match/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:help_match/features/notifications/repository/notif_repository.dart';
import 'package:help_match/features/onboarding/screen/onboarding_screen.dart';
import 'package:help_match/features/online_status/cubit/online_status_cubit.dart';
import 'package:help_match/features/online_status/repository/online_status_repository.dart';
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
  await initializeHive();

  await secureStorage.write(
      key: 'access_token',
      value:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImRhZyIsInJvbGUiOiJ1c2VyIiwiaXNzIjoiaHR0cHM6Ly9obS5iYXJuZXktaG9zdC5zaXRlIiwic3ViIjoiNDc0Zjk0MmMtZTE0NC0xMWVmLWI5YmYtMmYxM2Y2ODczMjhmIiwiYXVkIjpbImNvbS5iYXJuZXktaG9zdC5obSJdLCJleHAiOjE3MzkwOTE2NTUsImlhdCI6MTczODQ4Njg4NH0.rkLPnDV98EyJ3ItO_AquAROj8lTZNHIhIpFXrqi3B8g');

  final dio = Dio();

  dio.interceptors.add(AppDioInterceptor(secureStorage, userAuthCubit, dio));

  final themeModeString = await secureStorage.read(key: "theme_mode");
  if (themeModeString == null) {
    await secureStorage.write(key: 'theme_mode', value: 'light');
  }
  final initialThemeMode =
      (themeModeString == 'dark') ? ThemeMode.dark : ThemeMode.light;
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WsManager>(
          create: (_) => WsManager(secureStorage),
        ),
        RepositoryProvider<OnlineStatusRepository>(
          create: (context) =>
              OnlineStatusRepository(context.read<WsManager>()),
        ),
        RepositoryProvider<ChatRemoteDataProvider>(
          create: (_) => ChatRemoteDataProvider(dio: dio),
        ),
        RepositoryProvider<ChatRepository>(
          create: (context) => ChatRepository(
            context.read<ChatRemoteDataProvider>(),
            context.read<WsManager>(),
          ),
        ),
        RepositoryProvider<UserInfoRemoteProvider>(
          create: (_) => UserInfoRemoteProvider(dio),
        ),
        RepositoryProvider<UserLocalProvider>(
          create: (_) => UserLocalProvider(),
        ),
        RepositoryProvider<UserRepo>(
          create: (context) => UserRepo(
            context.read<UserInfoRemoteProvider>(),
            context.read<UserLocalProvider>(),
          ),
        ),
        RepositoryProvider<NotificationProvider>(
          create: (_) => NotificationProvider(dio: dio),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepository(
            context.read<NotificationProvider>(),
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
                create: (_) =>
                    OnlineStatusCubit(context.read<OnlineStatusRepository>()),
              ),
              BlocProvider(
                create: (_) => WebsocketCubit(context.read<WsManager>(), dio),
              ),
              BlocProvider(
                create: (_) => userAuthCubit,
              ),
              BlocProvider(
                create: (_) => ChatBloc(
                  context.read<ChatRepository>(),
                  context.read<UserRepo>(),
                ),
              ),
              BlocProvider(
                create: (_) => RoomsBloc(context.read<ChatRepository>()),
              ),
              BlocProvider(
                create: (_) =>
                    NotificationBloc(context.read<NotificationRepository>()),
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
      builder: (context, themeState) {
        return MaterialApp(
          title: 'HelpMatch',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeState,
          home: BlocListener<UserAuthCubit, UserAuthState>(
            listener: (context, state) {
              if (state is UserAuthIsLoggedIn) {
                context.read<WebsocketCubit>().connectCubit();
                context.read<OnlineStatusCubit>().listenOnlineStatusChange();
                context.read<ChatBloc>().add(NewMessageListening());
              }
            },
            child: BlocBuilder<UserAuthCubit, UserAuthState>(
              builder: (context, state) {
                if (state is UserAuthChecking) {
                  return const LoadingIndicator();
                } else if (state is UserAuthIsLoggedIn) {
                  final currentUser = context.read<UserAuthCubit>().currentUser;
                  if (currentUser!.role == "user") {
                    return const VolunteerScreen();
                  }
                  return const Scaffold();
                } else if (state is UserAuthInitial) {
                  return const OnBoardingScreen();
                } else {
                  return const Scaffold();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
