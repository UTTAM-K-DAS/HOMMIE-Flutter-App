import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/provider_model.dart';

class ProviderProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ProviderModel> _providers = [];
  ProviderModel? _selectedProvider;
  bool _isLoading = false;
  String? _error;

  List<ProviderModel> get providers => _providers;
  ProviderModel? get selectedProvider => _selectedProvider;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchProviders({
    String? category,
    double? minRating,
    bool? onlyAvailable,
  }) async {
    _setLoading(true);
    try {
      Query query = _db.collection('serviceProviders');

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      if (minRating != null) {
        query = query.where('rating', isGreaterThanOrEqualTo: minRating);
      }

      if (onlyAvailable == true) {
        query = query.where('isAvailable', isEqualTo: true);
      }

      final snapshot = await query.get();
      _providers = snapshot.docs
          .map((doc) =>
              ProviderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
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

  Future<ProviderModel?> getProviderById(String id) async {
    try {
      final doc = await _db.collection('serviceProviders').doc(id).get();
      if (!doc.exists) return null;
      _selectedProvider = ProviderModel.fromMap(doc.data()!, doc.id);
      notifyListeners();
      return _selectedProvider;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> updateProviderAvailability(String id, bool isAvailable) async {
    try {
      await _db.collection('serviceProviders').doc(id).update({
        'isAvailable': isAvailable,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      final index = _providers.indexWhere((p) => p.id == id);
      if (index != -1) {
        final provider = _providers[index];
        _providers[index] = ProviderModel(
          id: provider.id,
          name: provider.name,
          imageUrl: provider.imageUrl,
          rating: provider.rating,
          experience: provider.experience,
          category: provider.category,
          pricePerHour: provider.pricePerHour,
          isAvailable: isAvailable,
          services: provider.services,
          description: provider.description,
          contactInfo: provider.contactInfo,
          location: provider.location,
          reviews: provider.reviews,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addReview(
    String providerId,
    String userId,
    double rating,
    String comment,
  ) async {
    try {
      final review = {
        'userId': userId,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _db.collection('serviceProviders').doc(providerId).update({
        'reviews': FieldValue.arrayUnion([review]),
      });

      // Update the local provider data
      if (_selectedProvider?.id == providerId) {
        final updatedReviews = [..._selectedProvider!.reviews, review];
        _selectedProvider = ProviderModel(
          id: _selectedProvider!.id,
          name: _selectedProvider!.name,
          imageUrl: _selectedProvider!.imageUrl,
          rating: _selectedProvider!.rating,
          experience: _selectedProvider!.experience,
          category: _selectedProvider!.category,
          pricePerHour: _selectedProvider!.pricePerHour,
          isAvailable: _selectedProvider!.isAvailable,
          services: _selectedProvider!.services,
          description: _selectedProvider!.description,
          contactInfo: _selectedProvider!.contactInfo,
          location: _selectedProvider!.location,
          reviews: updatedReviews,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
