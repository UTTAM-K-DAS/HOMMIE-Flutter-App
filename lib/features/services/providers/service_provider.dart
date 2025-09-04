import 'package:flutter/material.dart';
import '../../../models/unified_service_model.dart';
import '../services/firestore_service.dart';

class ServiceProvider with ChangeNotifier {
  List<ServiceModel> _services = [];
  final FirestoreService _firestoreService = FirestoreService();

  List<ServiceModel> get services => _services;

  Future<void> fetchServices() async {
    _services = await _firestoreService.getServices();
    notifyListeners();
  }
}
