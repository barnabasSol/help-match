part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

final class VolunteerNotificationListRequested extends NotificationEvent {}

final class OrganizationNotificationListRequested extends NotificationEvent {}
