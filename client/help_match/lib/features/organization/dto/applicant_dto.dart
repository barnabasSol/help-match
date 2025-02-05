// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApplicantDto {
  final String volunteerId;
  final String username;
  final String name;
  final String profileIcon;
  final String jobId;
  final String status;
  final DateTime createdAt;
  ApplicantDto({
    required this.volunteerId,
    required this.username,
    required this.name,
    required this.profileIcon,
    required this.jobId,
    required this.status,
    required this.createdAt
  });

  ApplicantDto copyWith({
    String? volunteerId,
    String? username,
    String? name,
    String? profileIcon,
    String? jobId,
    String? status,
    DateTime? createdAt,
  }) {
    return ApplicantDto(
     volunteerId:  volunteerId ?? this.volunteerId,
    username:   username ?? this.username,
    name:   name ?? this.name,
    profileIcon:   profileIcon ?? this.profileIcon,
     jobId:  jobId ?? this.jobId,
      status: status ?? this.status,
     createdAt:  createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'volunteerId': volunteerId,
      'username': username,
      'name': name,
      'profileIcon': profileIcon,
      'jobId': jobId,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ApplicantDto.fromMap(Map<String, dynamic> map) {
    return ApplicantDto(
     volunteerId:  map['volunteer_id'] as String,
     username:  map['username'] as String,
     name:  map['name'] as String,
     profileIcon:  map['profile_icon'] as String,
     jobId:  map['job_id'] as String,
     status:  map['status'] as String,
     createdAt:  DateTime.parse(map['created_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApplicantDto.fromJson(String source) => ApplicantDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ApplicantDto(volunteerId: $volunteerId, username: $username, name: $name, profileIcon: $profileIcon, jobId: $jobId, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ApplicantDto other) {
    if (identical(this, other)) return true;
  
    return 
      other.volunteerId == volunteerId &&
      other.username == username &&
      other.name == name &&
      other.profileIcon == profileIcon &&
      other.jobId == jobId &&
      other.status == status &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return volunteerId.hashCode ^
      username.hashCode ^
      name.hashCode ^
      profileIcon.hashCode ^
      jobId.hashCode ^
      status.hashCode ^
      createdAt.hashCode;
  }
}
