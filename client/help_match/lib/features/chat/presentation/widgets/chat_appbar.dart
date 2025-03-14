import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String profileIcon;
  final String groupName;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback onSearchPressed;

  const ChatAppBar({
    super.key,
    required this.profileIcon,
    required this.groupName,
    required this.scaffoldKey,
    required this.onSearchPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileIcon),
            radius: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              groupName,
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearchPressed,
        ),
      ],
    );
  }
}
