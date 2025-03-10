class OrgCardDto {
  String id;
  String name;
  String userId;
  String profileIcon;
  String description;
  double proximity;
  Location location;
  bool isVerified;
  DateTime createdAt;
  String type;
  int version;

  OrgCardDto({
    required this.id,
    required this.name,
    required this.userId,
    required this.profileIcon,
    required this.description,
    required this.proximity,
    required this.location,
    required this.isVerified,
    required this.createdAt,
    required this.type,
    required this.version,
  });

  static String invertConvert(String interests) {
    if (interests == "for_profit") return "For Profit";
    if (interests == "non_profit") return "Non Profit";
    if (interests == "government") return "Government";
    if (interests == "community") return "Community";
    if (interests == "educational") return "Education";
    if (interests == "healthcare") return "Healthcare";
    return "Cultural";
  }

  factory OrgCardDto.fromJson(Map<String, dynamic> json) {
    return OrgCardDto(
      id: json['org_id'],
      name: json['org_name'],
      userId: json['user_id'],
      profileIcon: json['profile_icon'],
      description: json['description'],
      proximity: json['proximity'].toDouble(),
      location: Location.fromJson(json['location']),
      isVerified: json['is_verified'],
      createdAt: DateTime.parse(json['created_at']),
      type: json['type'],
      version: json['version'],
    );
  }

  // Convert OrgListResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'org_id': id,
      'org_name': name,
      'user_id': userId,
      'profile_icon': profileIcon,
      'description': description,
      'proximity': proximity,
      'location': location.toJson(),
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'type': type,
      'version': version,
    };
  }
}

class Location {
  double latitude;
  double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
