import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/unified_service_model.dart';

class SearchProvider with ChangeNotifier {
  double _minPrice = 0;
  double _maxPrice = 1000;
  String? _category;
  double _minRating = 0;
  bool _onlyAvailable = true;
  String _query = '';
  List<ServiceModel>? _searchResults;
  bool _isLoading = false;
  String? _error;

  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String? get category => _category;
  double get minRating => _minRating;
  bool get onlyAvailable => _onlyAvailable;
  String get query => _query;
  List<ServiceModel>? get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateFilters({
    double? minPrice,
    double? maxPrice,
    String? category,
    double? minRating,
    bool? onlyAvailable,
  }) {
    _minPrice = minPrice ?? _minPrice;
    _maxPrice = maxPrice ?? _maxPrice;
    _category = category;
    _minRating = minRating ?? _minRating;
    _onlyAvailable = onlyAvailable ?? _onlyAvailable;
    notifyListeners();
  }

  void updateQuery(String query) {
    _query = query;
    notifyListeners();
  }

  Future<void> search() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final servicesRef = FirebaseFirestore.instance.collection('services');
      Query query = servicesRef;

      // Apply category filter
      if (_category != null && _category!.isNotEmpty && _category != 'All') {
        query = query.where('category', isEqualTo: _category);
      }

      // Apply price range filter
      query = query
          .where('price', isGreaterThanOrEqualTo: _minPrice)
          .where('price', isLessThanOrEqualTo: _maxPrice);

      // Apply rating filter
      if (_minRating > 0) {
        query = query.where('rating', isGreaterThanOrEqualTo: _minRating);
      }

      // Apply availability filter
      if (_onlyAvailable) {
        query = query.where('isAvailable', isEqualTo: true);
      }

      // Apply text search if query is not empty
      if (_query.isNotEmpty) {
        // Get normalized search terms
        final searchTerms = _query.toLowerCase().split(' ');

        // Search in name and keywords
        query = query.where('searchTerms', arrayContainsAny: searchTerms);
      }

      // Execute query
      final querySnapshot = await query.get();

      // Convert to ServiceModel objects
      _searchResults = querySnapshot.docs
          .map((doc) =>
              ServiceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Sort results by relevance if there's a search query
      if (_query.isNotEmpty) {
        final searchTerms = _query.toLowerCase().split(' ');
        _searchResults!.sort((a, b) {
          // Calculate relevance score based on how many search terms match
          int scoreA = _calculateRelevanceScore(a, searchTerms);
          int scoreB = _calculateRelevanceScore(b, searchTerms);
          return scoreB.compareTo(scoreA); // Higher score first
        });
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int _calculateRelevanceScore(ServiceModel service, List<String> searchTerms) {
    int score = 0;
    final name = service.name.toLowerCase();
    final description = service.description.toLowerCase();

    for (final term in searchTerms) {
      if (name.contains(term)) score += 2; // Name matches are weighted higher
      if (description.contains(term)) score += 1;
    }

    return score;
  }

  void clearSearch() {
    _searchResults = null;
    _query = '';
    notifyListeners();
  }
}
