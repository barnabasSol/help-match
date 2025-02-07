import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/features/chat/presentation/bloc/rooms_bloc/rooms_bloc.dart';
import 'package:help_match/features/chat/presentation/pages/room_list_page.dart';
import 'package:help_match/features/organization/presentation/pages/home.dart';
import 'package:help_match/features/organization/presentation/pages/notification.dart';
import 'package:help_match/features/organization/presentation/pages/add_job.dart';
import 'package:help_match/main.dart';

class OrgScreen extends StatefulWidget {
  const OrgScreen({super.key});

  @override
  State<OrgScreen> createState() => _OrgScreenState();
}

class _OrgScreenState extends State<OrgScreen> {
  int _selectedPage = 2;
  final List _pages = [
    const OrgNotification(),
    const OrgHome(),
    // const AddJobPage(),
    const RoomListPage()
  ];
  void _changePage(int index) {
    setState(() {
      _selectedPage = index;
      if (_selectedPage == 2) {
        context.read<RoomsBloc>().add(RoomListRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add_sharp),
            label: "Applicants",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          // BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Job"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_sharp), label: "Rooms")
        ],
        onTap: _changePage,
        selectedItemColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
