part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationFetchRequested extends NotificationState {}

final class NotificationFetchLoading extends NotificationState {}

final class OrgNotificationFetchLoaded extends NotificationState {
  final List<OrgNotificationDto> notifList;
  OrgNotificationFetchLoaded(this.notifList);
}

final class VolunteerNotificationFetchLoaded extends NotificationState {
  final List<VolunteerNotificationDto> notifList;
  VolunteerNotificationFetchLoaded(this.notifList);
}

final class NotificationFetchError extends NotificationState {
  final String error;
  NotificationFetchError(this.error);
}
