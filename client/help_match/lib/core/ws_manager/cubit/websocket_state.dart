part of 'websocket_cubit.dart';

@immutable
sealed class WebsocketState {}

final class WebsocketInitial extends WebsocketState {}

final class WebsocketLoading extends WebsocketState {}

final class WebsocketConnected extends WebsocketState {}

final class WebsocketConnectionFailed extends WebsocketState {}

final class WebsocketConnectingFailed extends WebsocketState {}
