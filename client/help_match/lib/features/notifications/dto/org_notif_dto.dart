// type OrgNotification struct {
// 	VolunteerId           string `json:"volunteer_id"`
// 	VolunteerName         string `json:"volunteer_name"`
// 	VolunteerUsernameName string `json:"volunteer_username"`
// 	OnlineStatus          bool   `json:"online_status"`
// 	VolunteerProfileIcon  string `json:"profile_icon"`
// 	Message               string `json:"message"`
// }

class OrgNotificationDto {
  final String volunteerId;

  final String volunteerName;
  final String volunteerUsername;
  final bool onlineStatus;
  final String profileIcon;
  final String message;

  OrgNotificationDto(
    this.volunteerId,
    this.volunteerName,
    this.volunteerUsername,
    this.onlineStatus,
    this.profileIcon,
    this.message,
  );

  factory OrgNotificationDto.fromJson(Map<String, dynamic> json) {
    return OrgNotificationDto(
      json['volunteer_id'] ?? '',
      json['volunteer_name'] ?? '',
      json['volunteer_username'] ?? '',
      json['online_status'] ?? false,
      json['profile_icon'] ?? '',
      json['message'] ?? '',
    );
  }
}
