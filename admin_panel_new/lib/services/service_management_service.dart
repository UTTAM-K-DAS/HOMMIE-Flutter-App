import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/unified_service_model.dart';
import '../models/service_category_model.dart';

class ServiceManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _servicesCollection = 'services';
  final String _categoriesCollection = 'service_categories';

  // Service CRUD Operations
  Stream<List<ServiceModel>> getServices() {
    return _firestore
        .collection(_servicesCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<ServiceModel?> getService(String id) async {
    final doc = await _firestore.collection(_servicesCollection).doc(id).get();
    if (doc.exists) {
      return ServiceModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<String> addService(ServiceModel service) async {
    final docRef = await _firestore
        .collection(_servicesCollection)
        .add(service.toMap());
    return docRef.id;
  }

  Future<void> updateService(String id, ServiceModel service) async {
    await _firestore
        .collection(_servicesCollection)
        .doc(id)
        .update(service.toMap());
  }

  Future<void> deleteService(String id) async {
    await _firestore.collection(_servicesCollection).doc(id).delete();
  }

  // Category CRUD Operations
  Stream<List<ServiceCategoryModel>> getCategories() {
    return _firestore
        .collection(_categoriesCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ServiceCategoryModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<ServiceCategoryModel?> getCategory(String id) async {
    final doc = await _firestore
        .collection(_categoriesCollection)
        .doc(id)
        .get();
    if (doc.exists) {
      return ServiceCategoryModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<String> addCategory(ServiceCategoryModel category) async {
    final docRef = await _firestore
        .collection(_categoriesCollection)
        .add(category.toMap());
    return docRef.id;
  }

  Future<void> updateCategory(String id, ServiceCategoryModel category) async {
    await _firestore
        .collection(_categoriesCollection)
        .doc(id)
        .update(category.toMap());
  }

  Future<void> deleteCategory(String id) async {
    await _firestore.collection(_categoriesCollection).doc(id).delete();
  }

  // Get services by category
  Stream<List<ServiceModel>> getServicesByCategory(String categoryId) {
    return _firestore
        .collection(_servicesCollection)
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Search services
  Stream<List<ServiceModel>> searchServices(String query) {
    return _firestore
        .collection(_servicesCollection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Toggle service availability
  Future<void> toggleServiceAvailability(String id, bool isAvailable) async {
    await _firestore.collection(_servicesCollection).doc(id).update({
      'isAvailable': isAvailable,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
