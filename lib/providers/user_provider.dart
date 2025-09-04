import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/auth/models/user_model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _auth.currentUser != null;
  String? get userId => _auth.currentUser?.uid;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> init() async {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    _setLoading(true);
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        _user = UserModel.fromMap(doc.data()!, doc.id);
      } else {
        // Create new user document if it doesn't exist
        final newUser = UserModel(
          id: uid,
          name: _auth.currentUser?.displayName ?? 'User',
          email: _auth.currentUser?.email ?? '',
          phone: _auth.currentUser?.phoneNumber,
          photoURL: _auth.currentUser?.photoURL,
          isActive: true,
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(newUser.toMap());

        _user = newUser;
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
  }) async {
    if (_user == null) return;

    _setLoading(true);
    try {
      final updatedUser = _user!.copyWith(
        name: name,
        phone: phoneNumber,
        photoURL: profilePicture,
        lastUpdated: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.id)
          .update(updatedUser.toMap());

      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
