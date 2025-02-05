import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Navigation_Page_o extends StatefulWidget {
  const Navigation_Page_o({super.key});

  @override
  State<Navigation_Page_o> createState() => _Navigation_Page_oState();
}

class _Navigation_Page_oState extends State<Navigation_Page_o> {
  int _selectedIndex = 0; // location is selected 
  
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(37.42796133580664, -122.085749655962);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0, // Hide default app bar
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const Text(
                    'Organization Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Organization Description',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Map Container
            Expanded(
            
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.yellow,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                
                
                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.circular(16),
                  //   // child: Expanded(child: Container()),
                  //   child: GoogleMap(
                  //     initialCameraPosition: CameraPosition(
                  //       target: _initialPosition,
                  //       zoom: 14.0,
                  //     ),
                  //     myLocationEnabled: true,
                  //     myLocationButtonEnabled: false,
                  //     onMapCreated: (controller) => _mapController = controller,
                  //   ),
                  // ),




                ),
              ),




            ),





            
            // Change Location Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                // icon: const Icon(Icons.location_on),
                label: const Text('Change Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _changeLocation,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
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


  // ignore: non_constant_identifier_names
 _change_to_pages(int index) {
    
    if (index == 4) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/profileo')};}

    else if (index == 3) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homec')};}


    else if (index == 2) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homeo')};}


    else if (index == 1) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homen')};}
    }





  void _changeLocation() {
    // Implement location change logic
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}