import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;
import '../screens/firebase_setup_screen.dart';

class AdminStatusDebug extends StatefulWidget {
  const AdminStatusDebug({super.key});

  @override
  State<AdminStatusDebug> createState() => _AdminStatusDebugState();
}

class _AdminStatusDebugState extends State<AdminStatusDebug> {
  String _status = 'Checking...';
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _status = 'Not authenticated';
        });
        return;
      }

      developer.log('Current user UID: ${user.uid}', name: 'AdminDebug');
      developer.log('Current user email: ${user.email}', name: 'AdminDebug');

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        setState(() {
          _status = 'User document does not exist';
          _userData = {'uid': user.uid, 'email': user.email};
        });
        return;
      }

      final userData = userDoc.data();
      setState(() {
        _userData = userData;
        _status = userData?['role'] == 'admin'
            ? 'Authenticated as Admin ✅'
            : 'Authenticated but not admin ❌';
      });

      developer.log('User data: $userData', name: 'AdminDebug');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
      developer.log('Error checking admin status: $e', name: 'AdminDebug');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Admin Status Debug',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Status: $_status'),
            if (_userData != null) ...[
              const SizedBox(height: 8),
              const Text(
                'User Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...(_userData!.entries.map(
                (entry) => Text('${entry.key}: ${entry.value}'),
              )),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _checkAdminStatus,
                  child: const Text('Refresh'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _createAdminUser,
                  child: const Text('Make Current User Admin'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FirebaseSetupScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Setup Guide'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createAdminUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No user logged in')));
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? 'Admin User',
        'role': 'admin',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'profile': {
          'firstName': (user.displayName ?? 'Admin').split(' ').first,
          'lastName': (user.displayName ?? '').split(' ').length > 1
              ? (user.displayName!.split(' ').last)
              : '',
          'avatar': user.photoURL ?? '',
        },
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User promoted to admin!')));

      _checkAdminStatus();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
