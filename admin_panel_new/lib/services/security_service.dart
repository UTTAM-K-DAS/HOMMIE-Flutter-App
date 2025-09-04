import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

// Password strength levels
enum PasswordStrength { weak, fair, good, strong }

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check password strength
  PasswordStrength checkPasswordStrength(String password) {
    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    // Bonus for mixed case and numbers
    if (password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'))) {
      score++;
    }

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.fair;
    if (score <= 6) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  // Generate secure password
  String generateSecurePassword({int length = 12}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    final random = Random.secure();

    // Ensure at least one character from each category
    String password = '';
    password += 'abcdefghijklmnopqrstuvwxyz'[random.nextInt(26)];
    password += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[random.nextInt(26)];
    password += '0123456789'[random.nextInt(10)];
    password += '!@#\$%^&*()'[random.nextInt(10)];

    // Fill the rest randomly
    for (int i = 4; i < length; i++) {
      password += chars[random.nextInt(chars.length)];
    }

    // Shuffle the password
    List<String> passwordList = password.split('');
    passwordList.shuffle(random);

    return passwordList.join();
  }

  // Hash sensitive data
  String hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validate user permissions
  Future<bool> validateUserPermission(String userId, String permission) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();

      if (userData == null) return false;

      final roles = List<String>.from(userData['roles'] ?? []);
      final permissions = List<String>.from(userData['permissions'] ?? []);

      // Check direct permission
      if (permissions.contains(permission)) return true;

      // Check role-based permissions
      for (final role in roles) {
        final roleDoc = await _firestore.collection('roles').doc(role).get();
        final roleData = roleDoc.data();

        if (roleData != null) {
          final rolePermissions = List<String>.from(
            roleData['permissions'] ?? [],
          );
          if (rolePermissions.contains(permission)) return true;
        }
      }

      return false;
    } catch (e) {
      developer.log(
        'Error validating user permission: $e',
        name: 'SecurityService',
      );
      return false;
    }
  }

  // Log security event
  Future<void> logSecurityEvent({
    required String eventType,
    required String userId,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _firestore.collection('security_logs').add({
        'eventType': eventType,
        'userId': userId,
        'description': description,
        'metadata': metadata ?? {},
        'timestamp': FieldValue.serverTimestamp(),
        'ipAddress': await _getCurrentIPAddress(),
        'userAgent': await _getUserAgent(),
      });
    } catch (e) {
      developer.log(
        'Error logging security event: $e',
        name: 'SecurityService',
      );
    }
  }

  // Check for suspicious activity
  Future<bool> checkSuspiciousActivity(String userId) async {
    try {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(const Duration(hours: 1));

      // Check for multiple failed login attempts
      final failedLogins = await _firestore
          .collection('security_logs')
          .where('userId', isEqualTo: userId)
          .where('eventType', isEqualTo: 'failed_login')
          .where('timestamp', isGreaterThan: Timestamp.fromDate(oneHourAgo))
          .get();

      if (failedLogins.docs.length >= 5) {
        await logSecurityEvent(
          eventType: 'suspicious_activity',
          userId: userId,
          description: 'Multiple failed login attempts detected',
          metadata: {'failed_attempts': failedLogins.docs.length},
        );
        return true;
      }

      // Check for rapid API calls
      final apiCalls = await _firestore
          .collection('security_logs')
          .where('userId', isEqualTo: userId)
          .where('eventType', isEqualTo: 'api_call')
          .where('timestamp', isGreaterThan: Timestamp.fromDate(oneHourAgo))
          .get();

      if (apiCalls.docs.length >= 100) {
        await logSecurityEvent(
          eventType: 'suspicious_activity',
          userId: userId,
          description: 'Excessive API calls detected',
          metadata: {'api_calls': apiCalls.docs.length},
        );
        return true;
      }

      return false;
    } catch (e) {
      developer.log(
        'Error checking suspicious activity: $e',
        name: 'SecurityService',
      );
      return false;
    }
  }

  // Rate limiting
  Future<bool> isRateLimited(String userId, String action) async {
    try {
      final now = DateTime.now();
      final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

      final recentActions = await _firestore
          .collection('rate_limits')
          .where('userId', isEqualTo: userId)
          .where('action', isEqualTo: action)
          .where('timestamp', isGreaterThan: Timestamp.fromDate(oneMinuteAgo))
          .get();

      // Different limits for different actions
      int limit = _getActionLimit(action);

      if (recentActions.docs.length >= limit) {
        await logSecurityEvent(
          eventType: 'rate_limit_exceeded',
          userId: userId,
          description: 'Rate limit exceeded for action: $action',
          metadata: {'action': action, 'limit': limit},
        );
        return true;
      }

      // Record this action
      await _firestore.collection('rate_limits').add({
        'userId': userId,
        'action': action,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return false;
    } catch (e) {
      developer.log('Error checking rate limit: $e', name: 'SecurityService');
      return false;
    }
  }

  // Get action rate limit
  int _getActionLimit(String action) {
    switch (action) {
      case 'login':
        return 5;
      case 'password_reset':
        return 3;
      case 'api_call':
        return 60;
      case 'file_upload':
        return 10;
      default:
        return 10;
    }
  }

  // Sanitize input to prevent injection attacks
  String sanitizeInput(String input) {
    return input
        .replaceAll(
          RegExp(r'<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>'),
          '',
        )
        .replaceAll(RegExp(r'javascript:'), '')
        .replaceAll(RegExp(r'on\w+\s*='), '')
        .trim();
  }

  // Validate file upload security
  bool isSecureFileUpload(String fileName, List<int> fileBytes) {
    // Check file extension
    final allowedExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.pdf',
      '.doc',
      '.docx',
      '.txt',
    ];
    final fileExtension = fileName.toLowerCase().substring(
      fileName.lastIndexOf('.'),
    );

    if (!allowedExtensions.contains(fileExtension)) {
      return false;
    }

    // Check file size (max 10MB)
    if (fileBytes.length > 10 * 1024 * 1024) {
      return false;
    }

    // Check for malicious file signatures
    final fileSignature = fileBytes.take(8).join();
    final maliciousSignatures = [
      '7790801', // executable
      '77904', // executable
      '8075755', // compressed executable
    ];

    for (final signature in maliciousSignatures) {
      if (fileSignature.startsWith(signature)) {
        return false;
      }
    }

    return true;
  }

  // Generate secure token
  String generateSecureToken({int length = 32}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  // Encrypt sensitive data (basic implementation)
  String encryptData(String data, String key) {
    // This is a basic implementation. In production, use proper encryption libraries
    final bytes = utf8.encode(data + key);
    final digest = sha256.convert(bytes);
    return base64.encode(digest.bytes);
  }

  // Decrypt sensitive data (basic implementation)
  String decryptData(String encryptedData, String key) {
    // This is a placeholder. In production, implement proper decryption
    // For now, we'll return a placeholder
    return 'decrypted_data';
  }

  // Check if user session is valid
  Future<bool> isSessionValid(String userId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null || currentUser.uid != userId) {
        return false;
      }

      // Check if user is still in the database
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        return false;
      }

      // Check if user account is active
      final userData = userDoc.data();
      if (userData != null && userData['isActive'] == false) {
        return false;
      }

      return true;
    } catch (e) {
      developer.log(
        'Error checking session validity: $e',
        name: 'SecurityService',
      );
      return false;
    }
  }

  // Block user temporarily
  Future<void> blockUser(
    String userId,
    Duration duration,
    String reason,
  ) async {
    try {
      final unblockTime = DateTime.now().add(duration);

      await _firestore.collection('users').doc(userId).update({
        'isBlocked': true,
        'blockReason': reason,
        'blockedUntil': Timestamp.fromDate(unblockTime),
        'blockedAt': FieldValue.serverTimestamp(),
      });

      await logSecurityEvent(
        eventType: 'user_blocked',
        userId: userId,
        description: 'User blocked: $reason',
        metadata: {
          'duration': duration.inMinutes,
          'unblockTime': unblockTime.toIso8601String(),
        },
      );
    } catch (e) {
      developer.log('Error blocking user: $e', name: 'SecurityService');
    }
  }

  // Check if user is blocked
  Future<bool> isUserBlocked(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();

      if (userData == null) return false;

      final isBlocked = userData['isBlocked'] as bool? ?? false;
      if (!isBlocked) return false;

      final blockedUntil = userData['blockedUntil'] as Timestamp?;
      if (blockedUntil == null) return true;

      if (DateTime.now().isAfter(blockedUntil.toDate())) {
        // Unblock user automatically
        await _firestore.collection('users').doc(userId).update({
          'isBlocked': false,
          'blockReason': FieldValue.delete(),
          'blockedUntil': FieldValue.delete(),
        });
        return false;
      }

      return true;
    } catch (e) {
      developer.log(
        'Error checking if user is blocked: $e',
        name: 'SecurityService',
      );
      return false;
    }
  }

  // Get current IP address (placeholder)
  Future<String> _getCurrentIPAddress() async {
    // In a real app, you would get the actual IP address
    return 'unknown';
  }

  // Get user agent (placeholder)
  Future<String> _getUserAgent() async {
    // In a real app, you would get the actual user agent
    return 'admin_panel_flutter';
  }

  // Clean up old security logs
  Future<void> cleanupSecurityLogs() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 90));

      final oldLogs = await _firestore
          .collection('security_logs')
          .where('timestamp', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      for (final doc in oldLogs.docs) {
        await doc.reference.delete();
      }

      developer.log(
        'Cleaned up ${oldLogs.docs.length} old security logs',
        name: 'SecurityService',
      );
    } catch (e) {
      developer.log(
        'Error cleaning up security logs: $e',
        name: 'SecurityService',
      );
    }
  }

  // Get security statistics
  Future<Map<String, dynamic>> getSecurityStats() async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(const Duration(days: 1));
      final oneWeekAgo = now.subtract(const Duration(days: 7));

      // Failed logins in last 24 hours
      final failedLogins24h = await _firestore
          .collection('security_logs')
          .where('eventType', isEqualTo: 'failed_login')
          .where('timestamp', isGreaterThan: Timestamp.fromDate(oneDayAgo))
          .get();

      // Suspicious activities in last week
      final suspiciousActivities = await _firestore
          .collection('security_logs')
          .where('eventType', isEqualTo: 'suspicious_activity')
          .where('timestamp', isGreaterThan: Timestamp.fromDate(oneWeekAgo))
          .get();

      // Blocked users
      final blockedUsers = await _firestore
          .collection('users')
          .where('isBlocked', isEqualTo: true)
          .get();

      return {
        'failedLogins24h': failedLogins24h.docs.length,
        'suspiciousActivities7d': suspiciousActivities.docs.length,
        'blockedUsers': blockedUsers.docs.length,
      };
    } catch (e) {
      developer.log(
        'Error getting security stats: $e',
        name: 'SecurityService',
      );
      return {};
    }
  }
}
