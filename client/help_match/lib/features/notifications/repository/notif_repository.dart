import 'package:help_match/features/notifications/data_provider/remote/notif_provider.dart';
import 'package:help_match/features/notifications/dto/org_notif_dto.dart';
import 'package:help_match/features/notifications/dto/volunteer_notif_dto.dart';

class NotificationRepository {
  final NotificationProvider notificationProvider;

  NotificationRepository(this.notificationProvider);

  Future<List<VolunteerNotificationDto>> getVolunteerNotifications() async {
    try {
      final response = await notificationProvider.fetchVolunteerNotifications();

      final dynamic data = response['data'];

      if (data is List) {
        final List<VolunteerNotificationDto> notifList = data
            .map((json) => VolunteerNotificationDto.fromJson(json))
            .toList();
        return notifList;
      } else {
        throw Exception(
            'Invalid response format: Expected a list of rooms in the "data" field');
      }
    } catch (e) {
      throw Exception('Failed to parse rooms: $e');
    }
  }

  Future<List<OrgNotificationDto>> getOrgNotifications() async {
    try {
      final response = await notificationProvider.fetchOrgNotifications();

      final dynamic data = response['data'];

      if (data is List) {
        final List<OrgNotificationDto> notifList =
            data.map((json) => OrgNotificationDto.fromJson(json)).toList();
        return notifList;
      } else {
        throw Exception(
            'Invalid response format: Expected a list of rooms in the "data" field');
      }
    } catch (e) {
      throw Exception('Failed to parse rooms: $e');
    }
  }
}
