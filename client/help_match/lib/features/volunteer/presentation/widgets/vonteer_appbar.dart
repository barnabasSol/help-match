import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/online_status/cubit/online_status_cubit.dart';

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
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      snap: false,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
                top: 86,
                left: 16,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        profileIcon.isEmpty
                            ? 'https://pm1.narvii.com/7493/423673bdcc8ec508c9dc45009858f8469be890c5r1-915-623v2_uhq.jpg'
                            : profileIcon,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: BlocBuilder<OnlineStatusCubit, OnlineStatusState>(
                        builder: (context, state) {
                          Color dotColor;
                          if (state is OnlineStatusInitial) {
                            dotColor = Colors.grey;
                          } else if (state is OnlineStatusChange) {
                            dotColor = Colors.green;
                          } else if (state is OnlineStatusError) {
                            dotColor = Colors.red;
                          } else {
                            dotColor = Colors.orange;
                          }
                          return Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )),
            Positioned(
              bottom: 20,
              left: 15,
              child: Text(
                'Hello Volunteer, @$username',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: 16,
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Opens the drawer
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
