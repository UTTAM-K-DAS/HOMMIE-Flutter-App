import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ErrorHandlingService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static void logError(
    dynamic error, [
    StackTrace? stackTrace,
    String? context,
  ]) {
    _logger.e(
      'Error${context != null ? ' in $context' : ''}: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void logWarning(String message, [String? context]) {
    _logger.w('Warning${context != null ? ' in $context' : ''}: $message');
  }

  static void logInfo(String message, [String? context]) {
    _logger.i('Info${context != null ? ' in $context' : ''}: $message');
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message ?? 'Loading...')),
          ],
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color confirmColor = Colors.red,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static String getErrorMessage(dynamic error) {
    if (error is String) return error;

    // Firebase Auth errors
    if (error.toString().contains('user-not-found')) {
      return 'No user found with this email address.';
    }
    if (error.toString().contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    }
    if (error.toString().contains('user-disabled')) {
      return 'This account has been disabled.';
    }
    if (error.toString().contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later.';
    }
    if (error.toString().contains('network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    }

    // Firestore errors
    if (error.toString().contains('permission-denied')) {
      return 'You don\'t have permission to perform this action.';
    }
    if (error.toString().contains('unavailable')) {
      return 'Service temporarily unavailable. Please try again.';
    }

    // Generic errors
    if (error.toString().contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
