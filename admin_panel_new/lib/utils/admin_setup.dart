import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class AdminSetup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create an admin user account
  /// This should be called only once during initial setup
  static Future<void> createAdminUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      developer.log('Creating admin user...', name: 'AdminSetup');

      // Create the authentication account
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user account');
      }

      // Create the user document with admin role
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'name': name,
        'role': 'admin', // This is crucial for security rules
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'profile': {
          'firstName': name.split(' ').first,
          'lastName': name.split(' ').length > 1 ? name.split(' ').last : '',
          'avatar': '',
        },
      });

      developer.log(
        'Admin user created successfully: ${user.uid}',
        name: 'AdminSetup',
      );
    } catch (e) {
      developer.log('Error creating admin user: $e', name: 'AdminSetup');
      rethrow;
    }
  }

  /// Make an existing user an admin
  static Future<void> makeUserAdmin(String userEmail) async {
    try {
      developer.log('Making user admin: $userEmail', name: 'AdminSetup');

      // Find user by email
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('User not found with email: $userEmail');
      }

      final userDoc = querySnapshot.docs.first;
      await userDoc.reference.update({
        'role': 'admin',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      developer.log('User promoted to admin successfully', name: 'AdminSetup');
    } catch (e) {
      developer.log('Error making user admin: $e', name: 'AdminSetup');
      rethrow;
    }
  }

  /// Check if current user is admin
  static Future<bool> isCurrentUserAdmin() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return false;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return false;

      final userData = userDoc.data();
      return userData?['role'] == 'admin';
    } catch (e) {
      developer.log('Error checking admin status: $e', name: 'AdminSetup');
      return false;
    }
  }

  /// Setup temporary public rules for initial admin creation
  /// IMPORTANT: This is only for initial setup, change back to secure rules after!
  static Future<void> setupTemporaryPublicRules() async {
    developer.log('''
    IMPORTANT: To create your first admin user, you need to temporarily modify your Firestore rules.
    
    1. Go to Firebase Console -> Firestore -> Rules
    2. Replace the rules with:
    
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        match /{document=**} {
          allow read, write: if true;
        }
      }
    }
    
    3. Publish the rules
    4. Run the admin creation process
    5. IMMEDIATELY change back to your secure rules!
    
    ''', name: 'AdminSetup');
  }
}
