// This is a simple guide for creating an admin user
// You can use Firebase Console or create this programmatically

// Option 1: Use Firebase Console
// 1. Go to https://console.firebase.google.com/
// 2. Select your project (hommie-ea778)
// 3. Go to Authentication > Users
// 4. Click "Add user"
// 5. Enter email: admin@hommie.com
// 6. Enter password: Admin123!
// 7. Click "Add user"

// Option 2: Create programmatically
// Run this in your main app or a separate script
/*
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createAdminUser() async {
  try {
    UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: 'admin@hommie.com',
      password: 'Admin123!',
    );
    print('Admin user created: ${result.user?.email}');
  } catch (e) {
    print('Error creating admin user: $e');
  }
}
*/

// Test credentials for admin panel:
// Email: admin@hommie.com
// Password: Admin123!
