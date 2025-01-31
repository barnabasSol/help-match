import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:help_match/features/chat/presentation/pages/room_list_page.dart';
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
    const HomePage(),
    const ProfilePage(),
    const RoomListPage()
  ];

  static const List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        context.read<ChatBloc>().add(ChatRoomListRequested());
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
      ),
      body: _pages[_selectedIndex],
    );
  }
}
