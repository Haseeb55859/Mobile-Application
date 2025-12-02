// lib/widgets/map_widget.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double zoom;

  const SimpleMap({Key? key, required this.latitude, required this.longitude, this.zoom = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initial = CameraPosition(target: LatLng(latitude, longitude), zoom: zoom);
    return GoogleMap(
      initialCameraPosition: initial,
      markers: {
        Marker(markerId: MarkerId('me'), position: LatLng(latitude, longitude)),
      },
      myLocationEnabled: true,
      zoomControlsEnabled: false,
    );
  }
}
