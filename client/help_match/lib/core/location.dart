// import 'package:flutter/material.dart';
import 'package:help_match/core/current_user/data_provider/local.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart'; 

class LocationProvider {
  static Future<LatLng> getCurrentLocation(
      LocationLocalProvider locationLocalProvider) async {
    if (locationLocalProvider.getCurrentLocation() != null) {
      return locationLocalProvider.getCurrentLocation()!;
    }
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return const LatLng(0.0, 0.0);
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return const LatLng(0.0, 0.0);
      }
    }

    final locationData = await location.getLocation();
    locationLocalProvider.setCurrentLocation( 
        locationData.longitude!, locationData.latitude!
    );
    LatLng loc = LatLng(locationData.latitude!, locationData.longitude!);
    return loc;
  }
}
