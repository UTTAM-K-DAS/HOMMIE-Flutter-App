import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/unified_service_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'services';

  Future<List<ServiceModel>> getServices() async {
    try {
      final snapshot = await _db.collection(_collection).get();
      return snapshot.docs
          .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }

  Future<ServiceModel?> getService(String id) async {
    try {
      final doc = await _db.collection(_collection).doc(id).get();
      if (doc.exists) {
        return ServiceModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching service: $e');
      return null;
    }
  }

  Future<List<ServiceModel>> getServicesByCategory(String category) async {
    try {
      final snapshot = await _db
          .collection(_collection)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching services by category: $e');
      return [];
    }
  }

  Future<ServiceModel?> addService(ServiceModel service) async {
    try {
      final docRef = await _db.collection(_collection).add(service.toMap());
      final newDoc = await docRef.get();
      return ServiceModel.fromMap(newDoc.data()!, newDoc.id);
    } catch (e) {
      print('Error adding service: $e');
      return null;
    }
  }

  Future<bool> updateService(ServiceModel service) async {
    try {
      await _db.collection(_collection).doc(service.id).update(service.toMap());
      return true;
    } catch (e) {
      print('Error updating service: $e');
      return false;
    }
  }

  Future<bool> deleteService(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting service: $e');
      return false;
    }
  }
}
