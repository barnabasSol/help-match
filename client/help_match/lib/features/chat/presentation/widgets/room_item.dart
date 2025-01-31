import 'package:flutter/material.dart';

class RoomListItem extends StatelessWidget {
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
          ? const Icon(Icons.circle_outlined,
              color: Colors.grey) // Icon for no messages
          : seen!
              ? const Icon(Icons.check_circle,
                  color: Colors.green) // Icon for seen messages
              : const Icon(Icons.circle,
                  color: Colors.red, size: 12), // Icon for unseen messages
      onTap: () {
        print('Tapped on $roomName');
      },
    );
  }
}
