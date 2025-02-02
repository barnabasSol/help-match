// const TypeOnlineStatus = "online_status_change"

// ignore: constant_identifier_names
const String TypeOnlineStatus = "online_status_change";

class OnlineStatusModel {
  final String userId;
  final String userName;
  final bool status;

  OnlineStatusModel(this.userId, this.userName, this.status);

  factory OnlineStatusModel.fromJson(Map<String, dynamic> json) {
    return OnlineStatusModel(
      json['user_id'] as String,
      json['username'] as String,
      json['online_status'] as bool,
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': userName,
      'online_status': status,
    };
  }
}
