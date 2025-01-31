class WsEvent {
  final String type;
  final dynamic payload;

  WsEvent({required this.type, required this.payload});

  factory WsEvent.fromJSON(Map<String, dynamic> json) {
    return WsEvent(
      type: json['type'] as String,
      payload: json['payload'] as dynamic,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'type': type,
      'payload': payload,
    };
  }
}
