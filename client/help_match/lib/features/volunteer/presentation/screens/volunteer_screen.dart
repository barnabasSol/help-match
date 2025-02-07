import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/current_user/cubit/user_auth_cubit.dart';
import 'package:help_match/features/chat/presentation/bloc/rooms_bloc/rooms_bloc.dart';
import 'package:help_match/features/chat/presentation/pages/room_list_page.dart';
import 'package:help_match/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:help_match/features/notifications/presentation/pages/notif_list_page.dart';
import 'package:help_match/features/volunteer/presentation/pages/volunteer_home.dart';
import 'package:help_match/features/volunteer/presentation/pages/volunteer_profile.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreen();
}

class _VolunteerScreen extends State<VolunteerScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const VolunteerHome(),
    const ProfilePage(),
    const RoomListPage(),
    const NotificationListPage(),
  ];

  static const List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notifications',
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
            .add(NotificationListRequested(role: currentUser!.role));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: _bottomNavItems,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
