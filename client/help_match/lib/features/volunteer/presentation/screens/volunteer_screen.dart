import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/features/chat/presentation/bloc/rooms_bloc/rooms_bloc.dart';
import 'package:help_match/features/chat/presentation/pages/room_list_page.dart';
import 'package:help_match/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:help_match/features/notifications/presentation/pages/notif_list_page.dart';
import 'package:help_match/features/volunteer/presentation/pages/volunteer_home.dart';
import 'package:help_match/features/volunteer/presentation/pages/volunteer_profile.dart';
import 'package:help_match/features/volunteer/presentation/widgets/drawer_header.dart';

class VolunteerScreen extends StatefulWidget {
 
  const VolunteerScreen({super.key });

  @override
  State<VolunteerScreen> createState() => _VolunteerScreen();
}

class _VolunteerScreen extends State<VolunteerScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const VolunteerHome( ),
    const VolunteerProfile(),
    const RoomListPage(),
    const NotificationListPage(),
  ];

  static const List<GButton> _bottomNavItems = [
    GButton(icon: Icons.home, text: 'Home'),
    GButton(icon: Icons.person, text: 'Profile'),
    GButton(icon: Icons.chat, text: 'Chat'),
    GButton(
      icon: (Icons.notifications),
      text: 'Notice',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        context.read<RoomsBloc>().add(RoomListRequested());
      } else if (index == 3) {
        final currentUser = context.read<UserAuthCubit>().currentUser;
        context
            .read<NotificationBloc>()
            .add(NotificationListRequested(role: currentUser.role));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawer: Drawer(
          child: ListView(
            children: const [DrawerHeader_()],
          ),
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: GNav(
              rippleColor: Theme.of(context).colorScheme.tertiary,
              gap: 2,
              padding: const EdgeInsets.all(10),
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
              tabs: _bottomNavItems,
              color: Theme.of(context).colorScheme.onSecondary,
              activeColor: Theme.of(context).colorScheme.onPrimary,
              // unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              tabBackgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        body: _pages[_selectedIndex],
      ),
    );
  }
}
