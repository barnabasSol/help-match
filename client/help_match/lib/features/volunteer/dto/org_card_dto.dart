// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:latlong2/latlong.dart';

class OrgCardDto {
  final String org_id;
  final String org_name;
  final String user_id;
  final String profile_icon;
  final String description;
  final double proximity;
  final LatLng location;
  final String type;
  final bool is_verified;

  OrgCardDto({
    required this.org_id,
    required this.org_name,
    required this.user_id,
    required this.profile_icon,
    required this.description,
    required this.proximity,
    required this.location,
    required this.type,
    required this.is_verified,
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


  factory OrgCardDto.fromJson(Map<String, dynamic> map) {
    return OrgCardDto(
      org_id: map['org_id'] as String,
      org_name: map['org_name'] as String,
      user_id: map['user_id'] as String,
      profile_icon: map['profile_icon'] as String,
      description: map['description'] as String,
      proximity: map['proximity'] as double,
      location: LatLng(map['location']['latitude'],map['location']['longitude']),
      type: invertConvert(map['type'] as String),
      is_verified: map['is_verified'] as bool,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory OrgCardDto.fromJson(String source) => OrgCardDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrgCardDto(org_id: $org_id, org_name: $org_name, user_id: $user_id, profile_icon: $profile_icon, description: $description, proximity: $proximity, location: $location, type: $type, is_verified: $is_verified)';
  }

  @override
  bool operator ==(covariant OrgCardDto other) {
    if (identical(this, other)) return true;
  
    return 
      other.org_id == org_id &&
      other.org_name == org_name &&
      other.user_id == user_id &&
      other.profile_icon == profile_icon &&
      other.description == description &&
      other.proximity == proximity &&
      other.location == location &&
      other.type == type &&
      other.is_verified == is_verified;
  }

  @override
  int get hashCode {
    return org_id.hashCode ^
      org_name.hashCode ^
      user_id.hashCode ^
      profile_icon.hashCode ^
      description.hashCode ^
      proximity.hashCode ^
      location.hashCode ^
      type.hashCode ^
      is_verified.hashCode;
  }
}
