import 'package:flutter/material.dart';
import 'package:help_match/features/chat/dto/message_dto.dart';

class MessageCard extends StatelessWidget {
  final MessageDto msg;
  final bool isSentByme;
  const MessageCard({super.key, required this.msg, required this.isSentByme});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByme ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(msg.message),
          ),
        ),
      ),
    );
  }
}
