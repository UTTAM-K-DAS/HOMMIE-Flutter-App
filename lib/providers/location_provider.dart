import 'package:flutter/foundation.dart';

class LocationProvider with ChangeNotifier {
  double? _latitude;
  double? _longitude;
  String _address = '';

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String get address => _address;

  Future<void> getCurrentLocation() async {
    // Implement location logic
    notifyListeners();
  }

  void updateAddress(String newAddress) {
    _address = newAddress;
    notifyListeners();
  }
}
