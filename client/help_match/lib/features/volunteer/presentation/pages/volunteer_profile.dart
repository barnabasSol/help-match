import 'package:flutter/material.dart';
import 'package:help_match/shared/widgets/location_picker.dart';

import 'package:latlong2/latlong.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickedLocation = await showModalBottomSheet<LatLng>(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: LocationPicker(
                onLocationPicked: (location) {
                  Navigator.of(context).pop(location);
                },
              ),
            );
          },
        );

        if (pickedLocation != null) {
          print('Picked Location: $pickedLocation');
        }
      },
      child: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
