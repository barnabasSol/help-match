part of 'online_status_cubit.dart';

@immutable
sealed class OnlineStatusState {}

final class OnlineStatusInitial extends OnlineStatusState {}

final class OnlineStatusChange extends OnlineStatusState {
  final OnlineStatusModel osm;
  OnlineStatusChange(this.osm);
}

final class OnlineStatusError extends OnlineStatusState {
  final String error;
  OnlineStatusError(this.error);
}
