import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/unified_service_model.dart';

class HomeProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ServiceModel> _featuredServices = [];
  bool _isLoading = false;
  String? _error;

  List<ServiceModel> get featuredServices => _featuredServices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchFeaturedServices() async {
    _setLoading(true);
    try {
      final snapshot = await _db
          .collection('services')
          .where('isFeatured', isEqualTo: true)
          .limit(5)
          .get();

      _featuredServices = snapshot.docs
          .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchServicesByCategory(String category) async {
    _setLoading(true);
    try {
      final snapshot = await _db
          .collection('services')
          .where('category', isEqualTo: category)
          .get();

      _featuredServices = snapshot.docs
          .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
