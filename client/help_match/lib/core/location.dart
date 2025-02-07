// import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationProvider {
 static Future<LatLng>  getCurrentLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
       return const LatLng(0.0,0.0);
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return const LatLng(0.0,0.0);
      }
    }

    final locationData = await location.getLocation();

    LatLng loc = LatLng(locationData.latitude!, locationData.longitude!);
    return loc;
  }
}
