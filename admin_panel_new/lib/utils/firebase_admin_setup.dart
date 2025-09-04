import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAdminSetup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Creates an admin user with elevated privileges
  static Future<bool> createAdminUser({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      developer.log('Creating admin user: $email', name: 'FirebaseAdminSetup');

      // Create the user account
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user account');
      }

      // Update the display name
      await user.updateDisplayName(displayName);

      // Create user document with admin role
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'displayName': displayName,
        'role': 'admin',
        'isAdmin': true,
        'permissions': [
          'read_all',
          'write_all',
          'delete_all',
          'manage_users',
          'manage_providers',
          'manage_services',
          'manage_bookings',
          'view_analytics',
          'system_config',
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'adminLevel': 'super_admin',
      });

      developer.log(
        'Admin user created successfully: ${user.uid}',
        name: 'FirebaseAdminSetup',
      );

      return true;
    } catch (e) {
      developer.log(
        'Error creating admin user: $e',
        name: 'FirebaseAdminSetup',
        error: e,
      );
      return false;
    }
  }

  /// Promotes an existing user to admin
  static Future<bool> promoteToAdmin(String userId) async {
    try {
      developer.log(
        'Promoting user to admin: $userId',
        name: 'FirebaseAdminSetup',
      );

      await _firestore.collection('users').doc(userId).update({
        'role': 'admin',
        'isAdmin': true,
        'permissions': [
          'read_all',
          'write_all',
          'delete_all',
          'manage_users',
          'manage_providers',
          'manage_services',
          'manage_bookings',
          'view_analytics',
          'system_config',
        ],
        'updatedAt': FieldValue.serverTimestamp(),
        'adminLevel': 'admin',
      });

      developer.log(
        'User promoted to admin successfully: $userId',
        name: 'FirebaseAdminSetup',
      );

      return true;
    } catch (e) {
      developer.log(
        'Error promoting user to admin: $e',
        name: 'FirebaseAdminSetup',
        error: e,
      );
      return false;
    }
  }

  /// Creates sample data for testing
  static Future<bool> createSampleData() async {
    try {
      developer.log(
        'Creating sample data for testing',
        name: 'FirebaseAdminSetup',
      );

      // Create sample service categories
      final categories = [
        {
          'id': 'cleaning',
          'name': 'House Cleaning',
          'description': 'Professional house cleaning services',
          'iconUrl':
              'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=🧹',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'plumbing',
          'name': 'Plumbing',
          'description': 'Professional plumbing repair and installation',
          'iconUrl':
              'https://via.placeholder.com/100x100/2196F3/FFFFFF?text=🔧',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'electrical',
          'name': 'Electrical',
          'description': 'Professional electrical services',
          'iconUrl': 'https://via.placeholder.com/100x100/FF9800/FFFFFF?text=⚡',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'carpentry',
          'name': 'Carpentry',
          'description': 'Professional carpentry and woodwork',
          'iconUrl':
              'https://via.placeholder.com/100x100/8BC34A/FFFFFF?text=🔨',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (final category in categories) {
        await _firestore
            .collection('service_categories')
            .doc(category['id'] as String)
            .set(category);
      }

      // Create sample services
      final services = [
        {
          'id': 'home-cleaning',
          'name': 'Home Cleaning',
          'description':
              'Professional home cleaning service including all rooms, kitchen, and bathrooms',
          'category': 'cleaning',
          'imageUrl':
              'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Home+Cleaning',
          'price': 80.0,
          'duration': 120, // 2 hours
          'isAvailable': true,
          'rating': 4.5,
          'totalReviews': 150,
          'packages': [
            {
              'name': 'Basic',
              'description': 'Standard home cleaning',
              'price': 80.0,
            },
            {
              'name': 'Deep Clean',
              'description': 'Thorough deep cleaning',
              'price': 120.0,
            },
          ],
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'office-cleaning',
          'name': 'Office Cleaning',
          'description':
              'Professional office cleaning service for commercial spaces',
          'category': 'cleaning',
          'imageUrl':
              'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Office+Cleaning',
          'price': 60.0,
          'duration': 90,
          'isAvailable': true,
          'rating': 4.3,
          'totalReviews': 85,
          'packages': [
            {
              'name': 'Standard',
              'description': 'Regular office cleaning',
              'price': 60.0,
            },
          ],
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'plumbing-repair',
          'name': 'Plumbing Repair',
          'description':
              'Professional plumbing repair services for leaks, clogs, and fixtures',
          'category': 'plumbing',
          'imageUrl':
              'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Plumbing+Repair',
          'price': 100.0,
          'duration': 60,
          'isAvailable': true,
          'rating': 4.7,
          'totalReviews': 220,
          'packages': [
            {
              'name': 'Basic Repair',
              'description': 'Minor plumbing repairs',
              'price': 100.0,
            },
            {
              'name': 'Major Repair',
              'description': 'Complex plumbing issues',
              'price': 200.0,
            },
          ],
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'electrical-repair',
          'name': 'Electrical Repair',
          'description':
              'Professional electrical repair and installation services',
          'category': 'electrical',
          'imageUrl':
              'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Electrical+Repair',
          'price': 120.0,
          'duration': 90,
          'isAvailable': true,
          'rating': 4.6,
          'totalReviews': 180,
          'packages': [
            {
              'name': 'Basic',
              'description': 'Simple electrical repairs',
              'price': 120.0,
            },
            {
              'name': 'Installation',
              'description': 'New electrical installations',
              'price': 250.0,
            },
          ],
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (final service in services) {
        await _firestore
            .collection('services')
            .doc(service['id'] as String)
            .set(service);
      }

      // Create sample providers
      final providers = [
        {
          'id': 'provider_1',
          'name': 'Ahmed Hassan',
          'displayName': 'Ahmed Hassan',
          'email': 'ahmed@example.com',
          'phone': '+1234567890',
          'address': '123 Main St, City, State',
          'description':
              'Professional cleaning expert with 5+ years experience',
          'category': 'cleaning',
          'services': ['home-cleaning', 'office-cleaning'],
          'rating': 4.8,
          'completedJobs': 150,
          'pricePerHour': 50.0,
          'isActive': true,
          'isAvailable': true,
          'role': 'provider',
          'status': 'approved',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'provider_2',
          'name': 'Sarah Wilson',
          'displayName': 'Sarah Wilson',
          'email': 'sarah@example.com',
          'phone': '+1234567891',
          'address': '456 Oak Ave, City, State',
          'description': 'Licensed plumber with 8+ years experience',
          'category': 'plumbing',
          'services': ['plumbing-repair'],
          'rating': 4.9,
          'completedJobs': 220,
          'pricePerHour': 75.0,
          'isActive': true,
          'isAvailable': true,
          'role': 'provider',
          'status': 'approved',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'provider_3',
          'name': 'Mike Johnson',
          'displayName': 'Mike Johnson',
          'email': 'mike@example.com',
          'phone': '+1234567892',
          'address': '789 Pine St, City, State',
          'description': 'Certified electrician with 10+ years experience',
          'category': 'electrical',
          'services': ['electrical-repair'],
          'rating': 4.7,
          'completedJobs': 180,
          'pricePerHour': 80.0,
          'isActive': true,
          'isAvailable': true,
          'role': 'provider',
          'status': 'approved',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      for (final provider in providers) {
        await _firestore
            .collection('users')
            .doc(provider['id'] as String)
            .set(provider);
      }

      developer.log(
        'Sample data created successfully',
        name: 'FirebaseAdminSetup',
      );

      return true;
    } catch (e) {
      developer.log(
        'Error creating sample data: $e',
        name: 'FirebaseAdminSetup',
        error: e,
      );
      return false;
    }
  }

  /// Checks if the current user is an admin
  static Future<bool> isCurrentUserAdmin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;
      return data['isAdmin'] == true || data['role'] == 'admin';
    } catch (e) {
      developer.log(
        'Error checking admin status: $e',
        name: 'FirebaseAdminSetup',
        error: e,
      );
      return false;
    }
  }

  /// Gets admin user info
  static Future<Map<String, dynamic>?> getAdminUserInfo() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      developer.log(
        'Error getting admin user info: $e',
        name: 'FirebaseAdminSetup',
        error: e,
      );
      return null;
    }
  }

  /// Creates temporary open security rules for initial setup
  static String getTemporarySecurityRules() {
    return '''
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // TEMPORARY RULES FOR ADMIN SETUP - REPLACE AFTER ADMIN CREATION
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
''';
  }

  /// Creates production security rules with admin authentication
  static String getProductionSecurityRules() {
    return '''
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is admin
    function isAdmin() {
      return request.auth != null && 
             exists(/databases/\$(database)/documents/users/\$(request.auth.uid)) &&
             get(/databases/\$(database)/documents/users/\$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Users collection
    match /users/{userId} {
      allow read, write: if isAdmin();
      allow read, update: if isAuthenticated() && request.auth.uid == userId;
      allow create: if isAuthenticated();
      // Allow reading provider profiles for booking (main app needs this)
      allow read: if isAuthenticated() && resource.data.get('role', '') == 'provider';
    }
    
    // Providers collection (legacy - mainly for compatibility)
    match /providers/{providerId} {
      allow read, write: if isAdmin();
      allow read: if isAuthenticated();
    }
    
    // Services collection  
    match /services/{serviceId} {
      allow read, write: if isAdmin();
      allow read: if isAuthenticated(); // Allow all authenticated users to read services
    }
    
    // Service categories collection
    match /service_categories/{categoryId} {
      allow read, write: if isAdmin();
      allow read: if isAuthenticated(); // Allow all authenticated users to read categories
    }
    
    // Bookings collection
    match /bookings/{bookingId} {
      allow read, write: if isAdmin();
      allow read, create: if isAuthenticated();
      allow update: if isAuthenticated() && 
                       (request.auth.uid == resource.data.customerId || 
                        request.auth.uid == resource.data.providerId);
    }
    
    // Settings collection
    match /settings/{document} {
      allow read, write: if isAdmin();
      allow read: if isAuthenticated(); // Allow reading app settings
    }
    
    // Analytics collection
    match /analytics/{document} {
      allow read, write: if isAdmin();
    }
    
    // Allow reading public data for unauthenticated users (optional)
    match /public/{document} {
      allow read: if true;
    }
  }
}
''';
  }
}
