import 'package:help_match/features/volunteer/dto/job_view_dto.dart';
import 'package:latlong2/latlong.dart';

class OrgDto {
  String? id;
  String name;
  String? userId;
  String profileIcon;
  String? description;
  double? proximity;
  Location? location;
  bool isVerified;
  DateTime? createdAt;
  String type;
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
      name: json['org_result']['org_name'],
      // userId: json['user_id'],
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

  // Convert OrgListResponse to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'org_id': id,
  //     'org_name': name,
  //     'user_id': userId,
  //     'profile_icon': profileIcon,
  //     'description': description,
  //     'proximity': proximity,
  //     'location': location.toJson(),
  //     'is_verified': isVerified,
  //     'created_at': createdAt.toIso8601String(),
  //     'type': type,
  //     'version': version,
  //   };
  // }
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
