import 'package:flutter/material.dart';
import '../models/unified_service_model.dart';

class AppNavigation {
  static void navigateToSearch(BuildContext context) {
    Navigator.pushNamed(context, '/search');
  }

  static void navigateToService(
    BuildContext context, {
    required String name,
    required String icon,
    required Color color,
    required String description,
    required List<Map<String, dynamic>> providers,
  }) {
    Navigator.pushNamed(
      context,
      '/service',
      arguments: {
        'name': name,
        'icon': icon,
        'color': color,
        'description': description,
        'providers': providers,
      },
    );
  }

  static void navigateToBooking(
    BuildContext context, {
    required ServiceModel service,
    required Map<String, dynamic> package,
    required Color color,
  }) {
    Navigator.pushNamed(
      context,
      '/booking',
      arguments: {
        'service': service,
        'package': package,
        'color': color,
      },
    );
  }

  static void navigateToPayment(
    BuildContext context, {
    required ServiceModel service,
    required Map<String, dynamic> provider,
    required Map<String, dynamic> booking,
  }) {
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'service': service,
        'provider': provider,
        'booking': booking,
      },
    );
  }

  static void navigateToConfirmation(
    BuildContext context, {
    required ServiceModel service,
    required Map<String, dynamic> provider,
    required Map<String, dynamic> booking,
    required String paymentMethod,
  }) {
    Navigator.pushNamed(
      context,
      '/confirmation',
      arguments: {
        'service': service,
        'provider': provider,
        'booking': booking,
        'paymentMethod': paymentMethod,
      },
    );
  }

  static void navigateToTracking(
    BuildContext context, {
    required String bookingId,
    required ServiceModel service,
    required Map<String, dynamic> provider,
  }) {
    Navigator.pushNamed(
      context,
      '/tracking',
      arguments: {
        'bookingId': bookingId,
        'service': service,
        'provider': provider,
      },
    );
  }

  static void navigateToViewAll(
    BuildContext context, {
    required String title,
    required List<Map<String, dynamic>> services,
  }) {
    Navigator.pushNamed(
      context,
      '/view-all',
      arguments: {
        'title': title,
        'services': services,
      },
    );
  }

  static void navigateToBookingStatus(BuildContext context) {
    Navigator.pushNamed(context, '/booking-status');
  }

  static void navigateToBookings(BuildContext context) {
    Navigator.pushNamed(context, '/bookings');
  }

  static void navigateToDashboard(BuildContext context) {
    Navigator.pushNamed(context, '/dashboard');
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
