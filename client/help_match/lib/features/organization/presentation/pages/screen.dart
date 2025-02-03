import 'package:flutter/material.dart';
import 'package:help_match/features/organization/presentation/pages/home.dart';
import 'package:help_match/features/organization/presentation/pages/notification.dart';
import 'package:help_match/features/organization/presentation/pages/org_profile.dart';

class OrgScreen extends StatefulWidget {
  const OrgScreen({super.key});

  @override
  State<OrgScreen> createState() => _OrgScreenState();
}

class _OrgScreenState extends State<OrgScreen> {
  int _selectedPage = 0;
  final List _pages = [
    const OrgNotification(),
    const OrgHome(),
    const OrgProfile()
  ];
  void _changePage(int index) {
    setState(() {
      _selectedPage = index;
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
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: "Profile")
        ],
        onTap: _changePage,
      ),
    );
  }
}
