import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/provider_model.dart';

class ProviderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'providers';

  // Get all providers
  Stream<List<ProviderModel>> getProviders() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProviderModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get single provider
  Future<ProviderModel?> getProvider(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return ProviderModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Add provider
  Future<String> addProvider(ProviderModel provider) async {
    final docRef = await _firestore
        .collection(_collection)
        .add(provider.toMap());
    return docRef.id;
  }

  // Update provider
  Future<void> updateProvider(String id, ProviderModel provider) async {
    await _firestore.collection(_collection).doc(id).update(provider.toMap());
  }

  // Delete provider
  Future<void> deleteProvider(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Update provider status
  Future<void> updateProviderStatus(String id, String status) async {
    await _firestore.collection(_collection).doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Search providers
  Stream<List<ProviderModel>> searchProviders(String query) {
    return _firestore
        .collection(_collection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProviderModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
