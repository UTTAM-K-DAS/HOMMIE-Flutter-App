import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;

    try {
      final doc = await _db.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        _userModel = UserModel.fromMap(doc.data()!, doc.id);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    _setLoading(true);
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      await userCredential.user!.updateDisplayName(name);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign In failed');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Create/update user document in Firestore
      await _db.collection('users').doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
      }, SetOptions(merge: true));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? photoURL,
  }) async {
    if (_user == null) return;

    _setLoading(true);
    try {
      final updates = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (name != null) {
        updates['name'] = name;
        await _user!.updateDisplayName(name);
      }

      if (phone != null) {
        updates['phone'] = phone;
      }

      if (photoURL != null) {
        updates['photoURL'] = photoURL;
        await _user!.updatePhotoURL(photoURL);
      }

      await _db.collection('users').doc(_user!.uid).update(updates);
      await _loadUserData();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    if (_user == null || _user!.email == null) return;

    _setLoading(true);
    try {
      // Reauthenticate user before changing password
      final credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: currentPassword,
      );
      await _user!.reauthenticateWithCredential(credential);

      // Change password
      await _user!.updatePassword(newPassword);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAccount() async {
    if (_user == null) return;

    _setLoading(true);
    try {
      // Delete user data from Firestore
      await _db.collection('users').doc(_user!.uid).delete();

      // Delete user authentication
      await _user!.delete();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInAsGuest() async {
    _setLoading(true);
    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user!;

      // Create a guest user document in Firestore
      await _db.collection('users').doc(user.uid).set({
        'name': 'Guest User',
        'email': null,
        'isGuest': true,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
      }, SetOptions(merge: true));
    } finally {
      _setLoading(false);
    }
  }
}
