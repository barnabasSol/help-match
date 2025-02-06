import 'package:flutter/material.dart';
import 'package:help_match/shared/widgets/gradient_button.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class Navigation_Page_v extends StatefulWidget {
  const Navigation_Page_v({super.key});

  @override
  State<Navigation_Page_v> createState() => _Navigation_Page_vState();
}

class _Navigation_Page_vState extends State<Navigation_Page_v> {
  int _selectedIndex = 0; // navigation is selected
  bool _showMap = true;
  // late GoogleMapController _mapController;
  // final LatLng _initialPosition = const LatLng(37.42796133580664, -122.085749655962);

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
                         Text(
                          'Organization Name',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                      ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Organization Description',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                           fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                   CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).colorScheme.primary,
      
                    // backgroundImage: AssetImage('assets/organization_logo.png'),
                  ),
                ],
              ),
            ),

  
            // Map Content
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
                        // color: Colors.grey.withOpacity(0.2),
                        color: Theme.of(context).colorScheme.primary,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  // child: ClipRRect(
                    // borderRadius: BorderRadius.circular(16),
                 
                    // child: _showMap
                    //     ? GoogleMap(
                    //         initialCameraPosition: CameraPosition(
                    //           target: _initialPosition,
                    //           zoom: 14.0,
                    //         ),
                    //         myLocationEnabled: true,
                    //         onMapCreated: (controller) => _mapController = controller,
                    //       )

                    //     : _buildJobsList(),

                  ),
                ),
              ),
    

            // Volunteer Button
            SizedBox(
          width: double.infinity,
          child: GradientButton(
          // key: _formKey,
          text: 'Ready to Volunteer',
          // _change_to_Home,
          onPressed: (){},
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

  _change_to_pages(int index) {
    
    if (index == 4) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/profilev')};}

    else if (index == 3) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homec')};}


    else if (index == 2) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homev')};}


    else if (index == 1) {
        return {
          Navigator.pop(context),
          Navigator.pushNamed(context, '/homen')};}
    }


  @override
  void dispose() {
    // _mapController.dispose();
    super.dispose();
  }
}