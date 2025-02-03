import 'package:flutter/material.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  final String senderName;
  final String profileIcon;
  final DateTime sentTime;
  final String message;
  final bool isSeen;
  final bool isOther;

  const MessageCard({
    super.key,
    required this.senderName,
    required this.profileIcon,
    required this.sentTime,
    required this.isSeen,
    required this.isOther,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedTime = DateFormat('hh:mm a').format(sentTime);

    final Color backgroundColor = isOther ? Colors.grey[300]! : Colors.blue;
    final Color textColor = isOther ? Colors.black : Colors.white;
    final Color secondaryTextColor = isOther ? Colors.black54 : Colors.white70;

    return Align(
      alignment: isOther ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isOther)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      profileIcon == '' ? Secrets.DummyImage : profileIcon,
                    ),
                    radius: 18,
                  ),
                ),

              // Message content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      senderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Message text
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Sent time
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Seen/Unseen icon (only for current user)
              if (!isOther)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    isSeen ? Icons.done_all : Icons.done,
                    size: 18,
                    color: isSeen ? Colors.white : secondaryTextColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
