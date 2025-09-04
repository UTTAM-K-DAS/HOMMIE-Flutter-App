import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_management_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserManagementService _userService = UserManagementService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = credential.user;
      _setLoading(false);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(e.message ?? 'Login failed');
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred');
      return false;
    }
  }

  Future<bool> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = credential.user;

      // Create user document in Firestore
      if (_user != null) {
        final newUser = UserModel(
          id: _user!.uid,
          name: _user!.displayName ?? 'Admin User',
          email: email,
          role: 'admin',
          isActive: true,
          createdAt: DateTime.now(),
        );
        await _userService.createUser(newUser);
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(e.message ?? 'Registration failed');
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed');
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _auth.sendPasswordResetEmail(email: email);

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _setError(e.message ?? 'Password reset failed');
      return false;
    } catch (e) {
      _setLoading(false);
      _setError('An unexpected error occurred');
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
