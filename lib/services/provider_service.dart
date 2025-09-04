import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/provider_model.dart';

class ProviderService {
  static Stream<List<ProviderModel>> getProvidersByService(String serviceId) {
    // First try the dedicated providers collection
    return FirebaseFirestore.instance
        .collection('providers')
        .where('services', arrayContains: serviceId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => ProviderModel.fromFirestore(doc))
            .toList();
      }

      // If no providers found in providers collection, try users with provider role
      return [];
    });
  }

  static Stream<List<ProviderModel>> getAllActiveProviders() {
    // Get providers from both collections and merge them
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'provider')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _convertUserToProvider(doc)).toList());
  }

  static ProviderModel _convertUserToProvider(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProviderModel(
      id: doc.id,
      name: data['displayName'] ?? data['name'] ?? 'Unknown Provider',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      description: data['description'] ?? 'Professional service provider',
      category: data['category'] ?? 'general',
      imageUrl: data['photoURL'] ?? data['avatar'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.5,
      completedJobs: data['completedJobs'] ?? 0,
      pricePerHour: (data['pricePerHour'] as num?)?.toDouble() ?? 50.0,
      isAvailable: data['isAvailable'] ?? true,
      services: List<String>.from(data['services'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static Stream<List<ProviderModel>> getProvidersByCategory(String category) {
    // Check both providers collection and users with provider role
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'provider')
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _convertUserToProvider(doc)).toList());
  }

  static Future<List<ProviderModel>> searchProviders(String query) async {
    final providers = <ProviderModel>[];

    // Search in users collection
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'provider')
        .where('isActive', isEqualTo: true)
        .get();

    for (final doc in userQuery.docs) {
      final data = doc.data();
      final name = (data['displayName'] ?? data['name'] ?? '').toLowerCase();
      if (name.contains(query.toLowerCase())) {
        providers.add(_convertUserToProvider(doc));
      }
    }

    return providers;
  }
}
