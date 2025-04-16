// import 'package:help_match/features/volunteer/dto/job_view_dto.dart'; 
import 'package:help_match/core/box_types/box_types.dart';
import 'package:hive_ce/hive.dart';

part './job_view_dto.dart';
@HiveType(typeId: BoxTypes.ORG_DETAIL)
class OrgDto {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? userId;

  @HiveField(3)
  String profileIcon;

  @HiveField(4)
  String? description;

  @HiveField(5)
  double? proximity;

  @HiveField(6)
  Location? location;

  @HiveField(7)
  bool isVerified;

  @HiveField(8)
  DateTime? createdAt;

  @HiveField(9)
  String type;

  @HiveField(10)
  List<JobViewDto>? jobs;
  // int version;

  OrgDto(
      {this.userId,
      this.description,
      this.location,
      this.createdAt,
      this.id,
      required this.name,
      required this.profileIcon,
      this.proximity,
      required this.isVerified,
      required this.type,
      this.jobs});

  factory OrgDto.fromJson(Map<String, dynamic> json) {
    return OrgDto(
      id: json['org_id'],
      name: json['org_name'],
      // userId: json['user_id'],
      profileIcon: json['profile_icon'],
      // description: json['description'],
      proximity: json['proximity'].toDouble(),
      // location: LatLng.fromMap(json['location']),
      isVerified: json['is_verified'],
      // createdAt: DateTime.parse(json['created_at']),
      type: json['type'],
      // version: json['version'],
    );
  }
  factory OrgDto.fromMap(Map<String, dynamic> json) {
    return OrgDto(
      id: json['org_id'],
      name: json['org_result']['org_name'],
      userId: json['user_id'],
      profileIcon: json['org_result']['profile_icon'],
      description: json['org_result']['description'],
      location: Location.fromJson(json['org_result']['location']),
      isVerified: json['org_result']['is_verified'],
      createdAt: DateTime.parse(json['org_result']['created_at']),
      type: json['org_result']['type'],
      jobs: (json['jobs'] as List<dynamic>?)
          ?.map((json) => JobViewDto.fromJson(json))
          .toList(),
      // version: json['version'],
    );
  }

 
}

@HiveType(typeId: BoxTypes.LOCATIONS)
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
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

}
