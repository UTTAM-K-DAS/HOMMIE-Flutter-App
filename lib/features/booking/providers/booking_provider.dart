import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';
import '../../../core/services/notification_service.dart';
import '../../../models/unified_service_model.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String> createBooking({
    required String userId,
    required String serviceId,
    required DateTime dateTime,
    required double totalAmount,
    ServiceModel? service,
    String? notes,
    Map<String, dynamic>? extras,
  }) async {
    _setLoading(true);
    try {
      final bookingRef = _db.collection('bookings').doc();

      // If service is not provided, try to get from Firestore
      ServiceModel serviceToUse;
      if (service != null) {
        serviceToUse = service;
      } else {
        final serviceDoc =
            await _db.collection('services').doc(serviceId).get();
        if (!serviceDoc.exists) {
          throw Exception('Service not found');
        }
        final serviceDetails = serviceDoc.data()!;
        serviceToUse = ServiceModel.fromMap(serviceDetails, serviceId);
      }

      final booking = BookingModel(
        id: bookingRef.id,
        userId: userId,
        service: serviceToUse,
        dateTime: dateTime,
        status: 'pending',
        notes: notes,
        totalAmount: totalAmount,
        extras: extras,
        createdAt: DateTime.now(),
      );

      await bookingRef.set(booking.toMap());

      // Send notification to admin
      await _notificationService.sendNotification(
        title: 'New Booking',
        body: 'New booking from ${userId}',
      );

      return booking.id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Stream<List<BookingModel>> getUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final bookings = <BookingModel>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final serviceId = data['serviceId'];
        final serviceDoc =
            await _db.collection('services').doc(serviceId).get();

        if (serviceDoc.exists) {
          bookings.add(BookingModel.fromMap(data, doc.id));
        }
      }
      return bookings;
    });
  }

  Future<void> cancelBooking(String bookingId) async {
    _setLoading(true);
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'status': 'Cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Send notification to admin
      await _notificationService.sendNotification(
          title: 'Booking Cancelled',
          body: 'Booking $bookingId has been cancelled');
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> rateBooking(
    String bookingId,
    double rating,
    String review,
  ) async {
    _setLoading(true);
    try {
      final booking = await _db.collection('bookings').doc(bookingId).get();
      if (!booking.exists) throw Exception('Booking not found');

      final serviceId = booking.data()!['serviceId'];
      final serviceDoc = await _db.collection('services').doc(serviceId).get();

      if (!serviceDoc.exists) throw Exception('Service not found');

      final currentRating = serviceDoc.data()!['rating'] ?? 0.0;
      final totalRatings = serviceDoc.data()!['totalRatings'] ?? 0;

      // Calculate new rating
      final newRating =
          ((currentRating * totalRatings) + rating) / (totalRatings + 1);

      // Update service rating
      await _db.collection('services').doc(serviceId).update({
        'rating': newRating,
        'totalRatings': FieldValue.increment(1),
      });

      // Update booking
      await _db.collection('bookings').doc(bookingId).update({
        'rating': rating,
        'review': review,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateBookingStatus(
    String bookingId,
    String status, {
    String? serviceProviderId,
  }) async {
    _setLoading(true);
    try {
      final updates = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (serviceProviderId != null) {
        updates['serviceProviderId'] = serviceProviderId;

        // Get provider details
        final providerDoc = await _db
            .collection('serviceProviders')
            .doc(serviceProviderId)
            .get();
        if (providerDoc.exists) {
          final providerDetails = providerDoc.data();
          if (providerDetails != null) {
            updates['providerDetails'] =
                Map<String, dynamic>.from(providerDetails);
          }
        }
      }

      await _db.collection('bookings').doc(bookingId).update(updates);

      // Send notification to user
      await _notificationService.sendNotification(
          title: 'Booking Update',
          body: 'Your booking status has been updated to $status');
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePaymentStatus(
    String bookingId,
    String paymentStatus,
  ) async {
    _setLoading(true);
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'paymentStatus': paymentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<BookingModel>> getBookingsByStatus(String status) async {
    _setLoading(true);
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final querySnapshot = await _db
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status.toLowerCase())
          .orderBy('dateTime', descending: true)
          .get();

      final bookings = await Future.wait(
        querySnapshot.docs.map((doc) async {
          final data = doc.data();
          final serviceId = data['serviceId'];
          final serviceDoc =
              await _db.collection('services').doc(serviceId).get();

          if (!serviceDoc.exists) throw Exception('Service not found');

          final serviceData = serviceDoc.data()!;
          final service = ServiceModel.fromMap(serviceData, serviceId);

          return BookingModel.fromMap({
            ...data,
            'service': service.toMap(),
          }, doc.id);
        }),
      );

      return bookings;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      final doc = await _db.collection('bookings').doc(bookingId).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      final serviceId = data['serviceId'];
      final serviceDoc = await _db.collection('services').doc(serviceId).get();

      if (!serviceDoc.exists) return null;

      final serviceData = serviceDoc.data()!;
      final service = ServiceModel.fromMap(serviceData, serviceId);

      return BookingModel.fromMap({
        ...data,
        'service': service.toMap(),
      }, doc.id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Stream<BookingModel?> trackBooking(String bookingId) {
    return _db
        .collection('bookings')
        .doc(bookingId)
        .snapshots()
        .asyncMap((doc) async {
      if (!doc.exists) return null;

      final data = doc.data()!;
      final serviceId = data['serviceId'];
      final serviceDoc = await _db.collection('services').doc(serviceId).get();

      if (!serviceDoc.exists) return null;

      final serviceData = serviceDoc.data()!;
      final service = ServiceModel.fromMap(serviceData, serviceId);

      return BookingModel.fromMap({
        ...data,
        'service': service.toMap(),
      }, doc.id);
    });
  }
}
