import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      print('Sign up error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Password reset error: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(
      {String? displayName, String? photoURL}) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
      }
    } catch (e) {
      print('Update profile error: $e');
      rethrow;
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      print('Send verification error: $e');
      rethrow;
    }
  }

  // Check if email is verified
  bool get isEmailVerified {
    User? user = _firebaseAuth.currentUser;
    return user?.emailVerified ?? false;
  }

  // Reload current user
  Future<void> reloadUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
    } catch (e) {
      print('Reload user error: $e');
      rethrow;
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      print('Delete account error: $e');
      rethrow;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      }
    } catch (e) {
      print('Update password error: $e');
      rethrow;
    }
  }

  // Reauthenticate user
  Future<UserCredential?> reauthenticateWithCredential(
      String email, String password) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        return await user.reauthenticateWithCredential(credential);
      }
      return null;
    } catch (e) {
      print('Reauthenticate error: $e');
      rethrow;
    }
  }
}
