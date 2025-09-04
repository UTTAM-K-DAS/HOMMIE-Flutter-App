import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  static const LatLng defaultLocation = LatLng(23.8103, 90.4125); // Dhaka

  static Marker createProviderMarker(LatLng position) {
    return Marker(
      markerId: const MarkerId('provider'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }

  static Marker createUserMarker(LatLng position) {
    return Marker(
      markerId: const MarkerId('user'),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }
}
