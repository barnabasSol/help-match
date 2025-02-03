class RoomDto {
  final String? roomProfile;
  final String? roomId;
  final bool? isAdmin;
  final bool? isSeen;
  final String? roomName;
  final String? latestText;
  final DateTime? sentTime;

  RoomDto({
    required this.roomProfile,
    required this.roomId,
    required this.isAdmin,
    this.isSeen,
    required this.roomName,
    required this.latestText,
    required this.sentTime,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    return RoomDto(
      roomProfile: json['room_profile'],
      roomId: json['room_id'],
      isAdmin: json['is_admin'],
      isSeen: json['is_seen'],
      roomName: json['room_name'],
      latestText: json['latest_text'],
      sentTime:
          json['sent_time'] != null ? DateTime.parse(json['sent_time']) : null,
    );
  }

  RoomDto copyWith({
    String? roomProfile,
    String? roomId,
    bool? isAdmin,
    bool? isSeen,
    String? roomName,
    String? latestText,
    DateTime? sentTime,
  }) {
    return RoomDto(
      roomProfile: roomProfile ?? this.roomProfile,
      roomId: roomId ?? this.roomId,
      isAdmin: isAdmin ?? this.isAdmin,
      isSeen: isSeen ?? this.isSeen,
      roomName: roomName ?? this.roomName,
      latestText: latestText ?? this.latestText,
      sentTime: sentTime ?? this.sentTime,
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
