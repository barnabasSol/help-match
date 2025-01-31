class RoomDto {
  final String roomProfile;
  final String roomId;
  final bool isAdmin;
  final bool? isSeen; // Make isSeen nullable
  final String roomName;
  final String latestText;
  final String sentTime;

  RoomDto({
    required this.roomProfile,
    required this.roomId,
    required this.isAdmin,
    this.isSeen, // isSeen is now optional
    required this.roomName,
    required this.latestText,
    required this.sentTime,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    return RoomDto(
      roomProfile: json['room_profile'],
      roomId: json['room_id'],
      isAdmin: json['is_admin'],
      isSeen: json['is_seen'], // This can be null
      roomName: json['room_name'],
      latestText: json['latest_text'],
      sentTime: json['sent_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_profile': roomProfile,
      'room_id': roomId,
      'is_admin': isAdmin,
      'is_seen': isSeen,
      'room_name': roomName,
      'latest_text': latestText,
      'sent_time': sentTime,
    };
  }
}
