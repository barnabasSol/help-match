class VolunteerNotificationDto {
  final String orgId;
  final String profileIcon;
  final String orgType;
  final String orgName;
  final String message;
  final bool isVerified;

  VolunteerNotificationDto({
    required this.orgId,
    required this.profileIcon,
    required this.orgType,
    required this.orgName,
    required this.message,
    required this.isVerified,
  });

  factory VolunteerNotificationDto.fromJson(Map<String, dynamic> json) {
    return VolunteerNotificationDto(
      orgId: json['org_id'] ?? '',
      profileIcon: json['org_profile_icon'] ?? '',
      orgType: json['org_type'] ?? '',
      orgName: json['org_name'] ?? '',
      message: json['message'] ?? '',
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'org_id': orgId,
      'org_profile_icon': profileIcon,
      'org_type': orgType,
      'org_name': orgName,
      'message': message,
      'is_verified': isVerified,
    };
  }
}
