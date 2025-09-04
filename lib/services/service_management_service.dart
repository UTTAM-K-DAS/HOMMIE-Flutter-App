import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_category_model.dart';

class ServiceManagementService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collection = 'serviceCategories';

  // Get all service categories
  static Stream<List<ServiceCategoryModel>> getAllServiceCategories() {
    return _db.collection(collection).orderBy('name').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => ServiceCategoryModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Add service category
  static Future<String?> addServiceCategory(
      ServiceCategoryModel category) async {
    try {
      final docRef = await _db.collection(collection).add(category.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding service category: $e');
      return null;
    }
  }

  // Update service category
  static Future<bool> updateServiceCategory(
      String categoryId, Map<String, dynamic> updates) async {
    try {
      await _db.collection(collection).doc(categoryId).update(updates);
      return true;
    } catch (e) {
      print('Error updating service category: $e');
      return false;
    }
  }

  // Delete service category
  static Future<bool> deleteServiceCategory(String categoryId) async {
    try {
      await _db.collection(collection).doc(categoryId).delete();
      return true;
    } catch (e) {
      print('Error deleting service category: $e');
      return false;
    }
  }

  // Toggle category active status
  static Future<bool> toggleCategoryStatus(
      String categoryId, bool isActive) async {
    try {
      await _db.collection(collection).doc(categoryId).update({
        'isActive': isActive,
      });
      return true;
    } catch (e) {
      print('Error toggling category status: $e');
      return false;
    }
  }
}
