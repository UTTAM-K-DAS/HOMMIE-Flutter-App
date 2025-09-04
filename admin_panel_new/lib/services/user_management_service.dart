import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'users';

  // Create a new user
  Future<UserModel> createUser(UserModel user) async {
    try {
      final doc = await _firestore.collection(_collection).add(user.toMap());
      return user.copyWith(id: doc.id);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get all users
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get users by role
  Stream<List<UserModel>> getUsersByRole(String role) {
    return _firestore
        .collection(_collection)
        .where('role', isEqualTo: role)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get single user
  Future<UserModel?> getUser(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Update user
  Future<void> updateUser(String id, UserModel user) async {
    await _firestore.collection(_collection).doc(id).update(user.toMap());
  }

  // Toggle user active status
  Future<void> toggleUserStatus(String id, bool isActive) async {
    await _firestore.collection(_collection).doc(id).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete user (deactivate instead of actual deletion)
  Future<void> deactivateUser(String id) async {
    await _firestore.collection(_collection).doc(id).update({
      'isActive': false,
      'deactivatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Search users
  Stream<List<UserModel>> searchUsers(String query) {
    return _firestore
        .collection(_collection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get user statistics
  Future<Map<String, int>> getUserStats() async {
    final customersQuery = await _firestore
        .collection(_collection)
        .where('role', isEqualTo: 'customer')
        .get();

    final providersQuery = await _firestore
        .collection(_collection)
        .where('role', isEqualTo: 'provider')
        .get();

    final activeUsersQuery = await _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .get();

    return {
      'customers': customersQuery.docs.length,
      'providers': providersQuery.docs.length,
      'activeUsers': activeUsersQuery.docs.length,
      'totalUsers': customersQuery.docs.length + providersQuery.docs.length,
    };
  }

  // Update user role
  Future<void> updateUserRole(String id, String role) async {
    await _firestore.collection(_collection).doc(id).update({
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get current authenticated user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  // Get current user's role from Firestore
  Future<String?> getCurrentUserRole() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    try {
      final userDoc = await _firestore
          .collection(_collection)
          .where('email', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        return userDoc.docs.first.data()['role'] as String?;
      }
    } catch (e) {
      throw Exception('Failed to get user role: $e');
    }
    return null;
  }
}
