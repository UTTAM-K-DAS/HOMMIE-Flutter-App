import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: 'TK ');
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y HH:mm').format(dateTime);
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'in_progress':
        return 'In Progress';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
