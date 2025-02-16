// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

class VolProfileDto {
  Uint8List? img;
  String? name;
  String? username;
  String? email;
  List<String> addedInterests;
  List<String> removedInterests;
  VolProfileDto({
    this.img,
    this.name,
    this.username,
    this.email,
    required this.addedInterests,
    required this.removedInterests,
  });
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'interests_update': {
        "add":convertList(addedInterests),
        "remove":convertList(removedInterests)
      },
    };
  }
}
