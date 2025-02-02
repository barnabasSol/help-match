// ignore_for_file: constant_identifier_names

const String TypeNewMessage = "new_message";
const String TypeSendMessage = "send_message";

class MessageModel {
  final String message;
  final String fromId;
  final String toRoomId;
  final DateTime sentTime;

  MessageModel({
    required this.message,
    required this.fromId,
    required this.toRoomId,
    required this.sentTime,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'] as String,
      fromId: json['from_id'] as String,
      toRoomId: json['to_room_id'] as String,
      sentTime: DateTime.parse(json['sent_time']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'from_id': fromId,
      'to_room_id': toRoomId,
      'sent_time': sentTime.toUtc().toIso8601String(),
    };
  }
}

// class OnlineStatusModel {
//   final String userId;
//   final String userName;
//   final bool status;

//   OnlineStatusModel(this.userId, this.userName, this.status);

//   factory OnlineStatusModel.fromJson(Map<String, dynamic> json) {
//     return OnlineStatusModel(
//       json['user_id'] as String,
//       json['username'] as String,
//       json['online_status'] as bool,
//     );
//   }

//   // Convert instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'user_id': userId,
//       'username': userName,
//       'online_status': status,
//     };
//   }
// }
