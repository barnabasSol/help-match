import 'package:flutter/material.dart';
import 'package:help_match/features/chat/presentation/pages/room_messages.dart';

class RoomListItem extends StatelessWidget {
  final String roomId;
  final String roomProfile;
  final String roomName;
  final String latestText;
  final bool? seen;

  const RoomListItem({
    super.key,
    required this.roomProfile,
    required this.roomName,
    required this.latestText,
    required this.seen,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(roomProfile),
      ),
      title: Text(
        roomName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        seen == null ? 'no messages' : latestText,
        style: TextStyle(
          color:
              seen == null ? Colors.grey : (seen! ? Colors.grey : Colors.black),
          fontWeight: seen == null
              ? FontWeight.normal
              : (seen! ? FontWeight.normal : FontWeight.bold),
        ),
      ),
      trailing: seen == null
          ? const Icon(Icons.circle_outlined, color: Colors.grey)
          : seen!
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.circle, color: Colors.red, size: 12),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RoomMessagesPage(
              roomId: roomId,
              groupName: roomName,
              profileIcon: 'https://img.rasset.ie/00141e21-1600.jpg',
            ),
          ),
        );
      },
    );
  }
}
