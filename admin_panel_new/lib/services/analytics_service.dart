import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Revenue Analytics
  Future<Map<String, dynamic>> getRevenueAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final start =
          startDate ?? DateTime.now().subtract(const Duration(days: 30));
      final end = endDate ?? DateTime.now();

      final bookingsQuery = await _firestore
          .collection('bookings')
          .where('status', isEqualTo: 'completed')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .get();

      double totalRevenue = 0;
      Map<String, double> dailyRevenue = {};
      Map<String, double> serviceRevenue = {};

      for (final doc in bookingsQuery.docs) {
        final data = doc.data();
        final amount = (data['totalAmount'] ?? 0.0).toDouble();
        final date = (data['createdAt'] as Timestamp).toDate();
        final serviceName = data['service']?['name'] ?? 'Unknown';

        totalRevenue += amount;

        // Daily revenue
        final dateKey = DateFormat('yyyy-MM-dd').format(date);
        dailyRevenue[dateKey] = (dailyRevenue[dateKey] ?? 0) + amount;

        // Service revenue
        serviceRevenue[serviceName] =
            (serviceRevenue[serviceName] ?? 0) + amount;
      }

      return {
        'totalRevenue': totalRevenue,
        'dailyRevenue': dailyRevenue,
        'serviceRevenue': serviceRevenue,
        'averageOrderValue': bookingsQuery.docs.isNotEmpty
            ? totalRevenue / bookingsQuery.docs.length
            : 0.0,
        'totalOrders': bookingsQuery.docs.length,
      };
    } catch (e) {
      throw Exception('Failed to get revenue analytics: $e');
    }
  }

  // Booking Analytics
  Future<Map<String, dynamic>> getBookingAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final start =
          startDate ?? DateTime.now().subtract(const Duration(days: 30));
      final end = endDate ?? DateTime.now();

      final bookingsQuery = await _firestore
          .collection('bookings')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .get();

      Map<String, int> statusCount = {};
      Map<String, int> dailyBookings = {};
      Map<String, int> serviceBookings = {};
      double totalRating = 0;
      int ratedBookings = 0;

      for (final doc in bookingsQuery.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'unknown';
        final date = (data['createdAt'] as Timestamp).toDate();
        final serviceName = data['service']?['name'] ?? 'Unknown';
        final rating = data['rating']?.toDouble();

        // Status count
        statusCount[status] = (statusCount[status] ?? 0) + 1;

        // Daily bookings
        final dateKey = DateFormat('yyyy-MM-dd').format(date);
        dailyBookings[dateKey] = (dailyBookings[dateKey] ?? 0) + 1;

        // Service bookings
        serviceBookings[serviceName] = (serviceBookings[serviceName] ?? 0) + 1;

        // Rating calculation
        if (rating != null) {
          totalRating += rating;
          ratedBookings++;
        }
      }

      return {
        'totalBookings': bookingsQuery.docs.length,
        'statusCount': statusCount,
        'dailyBookings': dailyBookings,
        'serviceBookings': serviceBookings,
        'averageRating': ratedBookings > 0 ? totalRating / ratedBookings : 0.0,
        'completionRate':
            statusCount['completed'] != null && bookingsQuery.docs.isNotEmpty
            ? (statusCount['completed']! / bookingsQuery.docs.length) * 100
            : 0.0,
      };
    } catch (e) {
      throw Exception('Failed to get booking analytics: $e');
    }
  }

  // Provider Analytics
  Future<Map<String, dynamic>> getProviderAnalytics() async {
    try {
      final providersQuery = await _firestore.collection('providers').get();
      final bookingsQuery = await _firestore.collection('bookings').get();

      Map<String, int> providerBookings = {};
      Map<String, double> providerRatings = {};
      Map<String, int> providerRatingCounts = {};
      Map<String, double> providerRevenue = {};
      int activeProviders = 0;

      // Count active providers
      for (final doc in providersQuery.docs) {
        final data = doc.data();
        if (data['status'] == 'approved') {
          activeProviders++;
        }
      }

      // Analyze bookings per provider
      for (final doc in bookingsQuery.docs) {
        final data = doc.data();
        final providerId = data['providerId'] ?? 'unassigned';
        final rating = data['rating']?.toDouble();
        final amount = (data['totalAmount'] ?? 0.0).toDouble();

        if (providerId != 'unassigned') {
          // Booking count
          providerBookings[providerId] =
              (providerBookings[providerId] ?? 0) + 1;

          // Revenue
          if (data['status'] == 'completed') {
            providerRevenue[providerId] =
                (providerRevenue[providerId] ?? 0) + amount;
          }

          // Ratings
          if (rating != null) {
            providerRatings[providerId] =
                (providerRatings[providerId] ?? 0) + rating;
            providerRatingCounts[providerId] =
                (providerRatingCounts[providerId] ?? 0) + 1;
          }
        }
      }

      // Calculate average ratings
      Map<String, double> averageRatings = {};
      for (final providerId in providerRatings.keys) {
        final totalRating = providerRatings[providerId]!;
        final count = providerRatingCounts[providerId]!;
        averageRatings[providerId] = totalRating / count;
      }

      return {
        'totalProviders': providersQuery.docs.length,
        'activeProviders': activeProviders,
        'providerBookings': providerBookings,
        'providerRevenue': providerRevenue,
        'averageRatings': averageRatings,
        'topProviders': _getTopProviders(providerBookings, 5),
      };
    } catch (e) {
      throw Exception('Failed to get provider analytics: $e');
    }
  }

  // Service Analytics
  Future<Map<String, dynamic>> getServiceAnalytics() async {
    try {
      final servicesQuery = await _firestore.collection('services').get();
      final bookingsQuery = await _firestore.collection('bookings').get();

      Map<String, int> serviceBookings = {};
      Map<String, double> serviceRevenue = {};
      Map<String, double> serviceRatings = {};
      Map<String, int> serviceRatingCounts = {};

      for (final doc in bookingsQuery.docs) {
        final data = doc.data();
        final serviceName = data['service']?['name'] ?? 'Unknown';
        final amount = (data['totalAmount'] ?? 0.0).toDouble();
        final rating = data['rating']?.toDouble();

        // Booking count
        serviceBookings[serviceName] = (serviceBookings[serviceName] ?? 0) + 1;

        // Revenue
        if (data['status'] == 'completed') {
          serviceRevenue[serviceName] =
              (serviceRevenue[serviceName] ?? 0) + amount;
        }

        // Ratings
        if (rating != null) {
          serviceRatings[serviceName] =
              (serviceRatings[serviceName] ?? 0) + rating;
          serviceRatingCounts[serviceName] =
              (serviceRatingCounts[serviceName] ?? 0) + 1;
        }
      }

      // Calculate average ratings
      Map<String, double> averageServiceRatings = {};
      for (final serviceName in serviceRatings.keys) {
        final totalRating = serviceRatings[serviceName]!;
        final count = serviceRatingCounts[serviceName]!;
        averageServiceRatings[serviceName] = totalRating / count;
      }

      return {
        'totalServices': servicesQuery.docs.length,
        'serviceBookings': serviceBookings,
        'serviceRevenue': serviceRevenue,
        'averageServiceRatings': averageServiceRatings,
        'topServices': _getTopServices(serviceBookings, 5),
        'revenueByService': serviceRevenue,
      };
    } catch (e) {
      throw Exception('Failed to get service analytics: $e');
    }
  }

  // Customer Analytics
  Future<Map<String, dynamic>> getCustomerAnalytics() async {
    try {
      final usersQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'customer')
          .get();

      final bookingsQuery = await _firestore.collection('bookings').get();

      Map<String, int> customerBookings = {};
      Map<String, double> customerSpending = {};
      Map<String, DateTime> lastBookingDate = {};

      for (final doc in bookingsQuery.docs) {
        final data = doc.data();
        final customerId = data['userId'] ?? data['customerId'];
        final amount = (data['totalAmount'] ?? 0.0).toDouble();
        final date = (data['createdAt'] as Timestamp).toDate();

        if (customerId != null) {
          // Booking count
          customerBookings[customerId] =
              (customerBookings[customerId] ?? 0) + 1;

          // Spending
          if (data['status'] == 'completed') {
            customerSpending[customerId] =
                (customerSpending[customerId] ?? 0) + amount;
          }

          // Last booking date
          if (lastBookingDate[customerId] == null ||
              date.isAfter(lastBookingDate[customerId]!)) {
            lastBookingDate[customerId] = date;
          }
        }
      }

      // Calculate retention metrics
      final now = DateTime.now();
      int activeCustomers = 0; // Booked within last 30 days
      int retainedCustomers = 0; // More than 1 booking

      for (final customerId in customerBookings.keys) {
        final lastBooking = lastBookingDate[customerId];
        final bookingCount = customerBookings[customerId]!;

        if (lastBooking != null && now.difference(lastBooking).inDays <= 30) {
          activeCustomers++;
        }

        if (bookingCount > 1) {
          retainedCustomers++;
        }
      }

      return {
        'totalCustomers': usersQuery.docs.length,
        'activeCustomers': activeCustomers,
        'retainedCustomers': retainedCustomers,
        'customerBookings': customerBookings,
        'customerSpending': customerSpending,
        'averageOrdersPerCustomer': customerBookings.isNotEmpty
            ? customerBookings.values.reduce((a, b) => a + b) /
                  customerBookings.length
            : 0.0,
        'customerRetentionRate': usersQuery.docs.isNotEmpty
            ? (retainedCustomers / usersQuery.docs.length) * 100
            : 0.0,
      };
    } catch (e) {
      throw Exception('Failed to get customer analytics: $e');
    }
  }

  // Helper method to get top providers
  List<MapEntry<String, int>> _getTopProviders(
    Map<String, int> providerBookings,
    int limit,
  ) {
    final sortedProviders = providerBookings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedProviders.take(limit).toList();
  }

  // Helper method to get top services
  List<MapEntry<String, int>> _getTopServices(
    Map<String, int> serviceBookings,
    int limit,
  ) {
    final sortedServices = serviceBookings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedServices.take(limit).toList();
  }

  // Generate comprehensive dashboard data
  Future<Map<String, dynamic>> getDashboardAnalytics() async {
    try {
      final revenueData = await getRevenueAnalytics();
      final bookingData = await getBookingAnalytics();
      final providerData = await getProviderAnalytics();
      final serviceData = await getServiceAnalytics();
      final customerData = await getCustomerAnalytics();

      return {
        'revenue': revenueData,
        'bookings': bookingData,
        'providers': providerData,
        'services': serviceData,
        'customers': customerData,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('Failed to generate dashboard analytics: $e');
    }
  }
}

// Analytics chart data model
class ChartData {
  final String x;
  final double y;
  final Color? color;

  ChartData(this.x, this.y, [this.color]);
}
