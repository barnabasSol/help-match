part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

final class NotificationListRequested extends NotificationEvent {
  final String role;
  NotificationListRequested({required this.role});
}
