import 'package:flutter/material.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class Navigation_Page_o extends StatefulWidget {
  const Navigation_Page_o({super.key});

  @override
  State<Navigation_Page_o> createState() => _Navigation_Page_oState();
}

class _Navigation_Page_oState extends State<Navigation_Page_o> {
  int _selectedIndex = 0; // location is selected 
  
  // late GoogleMapController _mapController;
  // final LatLng _initialPosition = const LatLng(37.42796133580664, -122.085749655962);

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
                   Text(
                    'Organization Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Organization Description',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.tertiary,
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Theme.of(context).colorScheme.primary,
      
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),


                ),
              ),




            ),





            
            // Change Location Button    
           SizedBox(
        width: double.infinity,
        child: GradientButton(
          // key: _formKey,
          text: 'Change Location',
          // _change_to_Home,
          onPressed: _changeLocation,
          // _selectedInterests.isEmpty? null : _change_to_Home,
          fontSize: 16,)
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
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.tertiary,
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
    // _mapController.dispose();
    super.dispose();
  }
}