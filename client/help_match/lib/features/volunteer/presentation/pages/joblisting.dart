import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Joblisting extends StatefulWidget {
  const Joblisting({super.key});

  @override
  State<Joblisting> createState() => _JoblistingState();
}

class _JoblistingState extends State<Joblisting> {
  int _selectedIndex = 2; 
  bool _showMap = true;
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(37.42796133580664, -122.085749655962);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Organization Name',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Organization Description',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.yellow,
                    // backgroundImage: AssetImage('assets/organization_logo.png'),
                  ),
                ],
              ),
            ),


            // Map/Jobs Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    // color: Colors.yellow ,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.2),
                        // color: Colors.yellow,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  

                     child: _buildJobsList(),

             





                ),
              ),
            ),

            // Volunteer Button
      ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildJobsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: const Icon(Icons.work, color: Colors.green),
            title: const Text('Volunteer Job Title'),
            subtitle: Text('Volunteer Job Description'),
            // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) => setState(() => _selectedIndex = _change_to_pages(index)),
    );
  }

  _change_to_pages(int index) {

    if (index == 0) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/navv')};}
    
    else if (index == 1) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homen')};}
    
    else if (index == 2) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homev')};}

    else if (index == 3) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homec')};}

    else if (index == 4) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/profilev')};}
    }


  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}