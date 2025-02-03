// type Message struct {
// 	SenderProfileIcon string    `json:"sender_profile"`
// 	SenderId          string    `json:"sender_id"`
// 	SenderName        string    `json:"sender_name"`
// 	SenderUsername    string    `json:"sender_username"`
// 	IsAdmin           bool      `json:"is_admin"`
// 	RoomId            string    `json:"room_id"`
// 	Message           string    `json:"message"`
// 	SentTime          time.Time `json:"sent_time"`
// 	IsSeen            bool      `json:"is_seen"`
// }
// ignore: constant_identifier_names

class MessageDto {
  final String senderProfileIcon;
  final String senderId;
  final String senderName;
  final String senderUsername;
  final bool isAdmin;
  final String roomId;
  final String message;
  final DateTime sentTime;
  final bool isSeen;

  MessageDto({
    required this.senderProfileIcon,
    required this.senderId,
    required this.senderName,
    required this.senderUsername,
    required this.isAdmin,
    required this.roomId,
    required this.message,
    required this.sentTime,
    required this.isSeen,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      senderProfileIcon: json['sender_profile'],
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      senderUsername: json['sender_username'],
      isAdmin: json['is_admin'],
      roomId: json['room_id'],
      message: json['message'],
      sentTime: DateTime.parse(json['sent_time']),
      isSeen: json['is_seen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_profile': senderProfileIcon,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_username': senderUsername,
      'is_admin': isAdmin,
      'room_id': roomId,
      'message': message,
      'sent_time': sentTime.toIso8601String(),
      'is_seen': isSeen,
    };
  }
}
