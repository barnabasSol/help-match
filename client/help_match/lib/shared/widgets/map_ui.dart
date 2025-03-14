<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapUi extends StatefulWidget {
  final LatLng location;
  const MapUi(this.location, {super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}

class _MapUiState extends State<MapUi> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(widget.location, 15.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.location,
        minZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: widget.location,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapUi extends StatefulWidget {
  final LatLng location;
  const MapUi(this.location, {super.key});

  @override
  State<MapUi> createState() => _MapUiState();
}

class _MapUiState extends State<MapUi> {
  final MapController _mapController = MapController();
@override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(widget.location, 15.0);
    });
  }
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.location,
        minZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: widget.location,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
>>>>>>> 2d1e7b1cc1ab872d7d29dfc46811c939013e7065
