import 'package:help_match/core/box_types/box_types.dart';
import 'package:hive_ce/hive.dart';

part 'user_cache_model.g.dart';

@HiveType(typeId: BoxTypes.USER)
class User {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String username;

  @HiveField(3)
  String email;

  @HiveField(4)
  String profilePicUrl;

  @HiveField(5)
  bool isActivated;

  @HiveField(6)
  bool isOnline;

  @HiveField(7)
  List<String>? interests;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  int version;

  @HiveField(10)
  OrgInfo? orgInfo;

  @HiveField(11)
  String role;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.profilePicUrl,
    required this.isActivated,
    required this.isOnline,
    this.interests,
    required this.createdAt,
    required this.version,
    this.orgInfo,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        profilePicUrl: json['profile_pic_url'] as String,
        isActivated: json['is_activated'] as bool,
        isOnline: json['is_online'] as bool,
        role: json['role'] as String,
        interests: json['interests'] != null
            ? List<String>.from(json['interests'])
            : null,
        createdAt: DateTime.parse(json['created_at'] as String),
        version: json['version'] as int,
        orgInfo: json['org_info'] != null
            ? OrgInfo.fromJson(json['org_info'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id, // Add this line
        'name': name,
        'username': username,
        'email': email,
        'profile_pic_url': profilePicUrl,
        'is_activated': isActivated,
        'is_online': isOnline,
        'role': role,
        'interests': interests,
        'created_at': createdAt.toIso8601String(),
        'version': version,
        'org_info': orgInfo?.toJson(),
      };
}

@HiveType(typeId: BoxTypes.ORG_INFO)
class OrgInfo {
  @HiveField(0)
  String orgId;

  @HiveField(1)
  String name;

  @HiveField(2)
  String profileIcon;

  @HiveField(3)
  String description;

  @HiveField(4)
  Location location;

  @HiveField(5)
  bool isVerified;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String type;

  @HiveField(8)
  int version;

  OrgInfo({
    required this.orgId,
    required this.name,
    required this.profileIcon,
    required this.description,
    required this.location,
    required this.isVerified,
    required this.createdAt,
    required this.type,
    required this.version,
  });
  factory OrgInfo.fromJson(Map<String, dynamic> json) => OrgInfo(
        orgId: json['org_id'] as String,
        name: json['org_name'] as String,
        profileIcon: json['profile_icon'] as String,
        description: json['description'] as String,
        location: Location.fromJson(json['location']),
        isVerified: json['is_verified'] as bool,
        createdAt: DateTime.parse(json['created_at'] as String),
        type: json['type'] as String,
        version: json['version'] as int,
      );
  Map<String, dynamic> toJson() => {
        'org_id': orgId,
        'org_name': name,
        'profile_icon': profileIcon,
        'description': description,
        'location': location.toJson(),
        'is_verified': isVerified,
        'created_at': createdAt.toIso8601String(),
        'type': type,
        'version': version,
      };
}

@HiveType(typeId: BoxTypes.LOCATION)
class Location {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
