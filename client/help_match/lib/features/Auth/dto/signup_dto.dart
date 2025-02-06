// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:latlong2/latlong.dart';

class UserSignUpDto {
  final String name;
  final String userName;
  final String email;
  List<String> interests;
  final String password;
  final String role = "user";

  UserSignUpDto({
    required this.name,
    required this.userName,
    required this.email,
    required this.interests,
    required this.password,
  });

  UserSignUpDto copyWith({
    String? name,
    String? userName,
    String? email,
    List<String>? interests,
    String? password,
  }) {
    return UserSignUpDto(
      name: name ?? this.name,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      interests: interests ?? this.interests,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': userName,
      'email': email,
      'interests': convertList(interests),
      'password': password,
      'role': "user"
    };
  }

  List<String> convertList(List<String> interests) {
    return List<String>.from(interests.map((i) {
      if (i == "For Profit") return "for_profit";
      if (i == "Non Profit") return "non_profit";
      if (i == "Government") return "government";
      if (i == "Community") return "community";
      if (i == "Education") return "educational";
      if (i == "Healthcare") return "healthcare";
      if (i == "Cultural") return "cultural";
    }));
    //return interests;
  }

  factory UserSignUpDto.fromMap(Map<String, dynamic> map) {
    return UserSignUpDto(
      name: map['name'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      interests: List<String>.from((map['interests'] as List<String>)),
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSignUpDto.fromJson(String source) =>
      UserSignUpDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserSignUpDto(name: $name, userName: $userName, email: $email, interests: $interests, password: $password)';
  }

  @override
  bool operator ==(covariant UserSignUpDto other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        other.userName == userName &&
        other.email == email &&
        listEquals(other.interests, interests) &&
        other.password == password;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        userName.hashCode ^
        email.hashCode ^
        interests.hashCode ^
        password.hashCode;
  }
}

class OrgSignUpDto {
  final String orgname;
  final String description;
  final String type;
  LatLng? location;
  final String name;
  final String username;
  final String email;
  final String password;
  String role = "organization";

  OrgSignUpDto({
    required this.orgname,
    required this.description,
    required this.type,
    this.location,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "org_info": {
        'org_name': orgname,
        'description': description,
        'location': location!=null
            ? {
                "latitude": location!.latitude,
                "longitude": location!.longitude
              }
            : {
         
            },
        'type':convert(type)
      },
      "name": name,
      "username": username,
      "email": email,
      "password": password,
      "role": role
    };
  }

  OrgSignUpDto copyWith({
    String? orgname,
    String? desc,
    LatLng? location,
    String? name,
    String? username,
    String? email,
    String? password,
    String? type,
  }) {
    return OrgSignUpDto(
        name: name ?? this.name,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        description: desc ?? description,
        location: location ?? this.location,
        type: type ?? this.type,
        orgname: orgname ?? this.orgname);
  }

  String convert(String interests) {
    if (interests == "For Profit") return "for_profit";
    if (interests == "Non Profit") return "non_profit";
    if (interests == "Government") return "government";
    if (interests == "Community") return "community";
    if (interests == "Education") return "educational";
    if (interests == "Healthcare") {
      return "healthcare";
    } else {
      return "cultural";
    }
  }
  //return interests;
}
