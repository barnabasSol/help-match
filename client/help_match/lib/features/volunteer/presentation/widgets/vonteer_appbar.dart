import 'package:flutter/material.dart';

class VolunteerAppbar extends StatelessWidget {
  final String profileIcon;
  final String username;
  const VolunteerAppbar({
    super.key,
    required this.profileIcon,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Background image or color
            Positioned.fill(
              child: Image.network(
                'https://pm1.narvii.com/7493/423673bdcc8ec508c9dc45009858f8469be890c5r1-915-623v2_uhq.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Profile icon
            Positioned(
              left: 16,
              top: 16,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  profileIcon == ""
                      ? 'https://pm1.narvii.com/7493/423673bdcc8ec508c9dc45009858f8469be890c5r1-915-623v2_uhq.jpg'
                      : profileIcon,
                ),
              ),
            ),
            // User name
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                'Welcome Volunteer, $username',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
