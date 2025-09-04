import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';
import '../models/unified_service_model.dart';

class BookingService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String collection = 'bookings';

  // Create a new booking
  static Future<String?> createBooking({
    required String providerId,
    required String providerName,
    required ServiceModel service,
    required DateTime dateTime,
    required String address,
    required String userPhone,
    String? notes,
    Map<String, dynamic>? userLocation,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Get user data
      final userDoc = await _db.collection('users').doc(user.uid).get();
      final userName = userDoc.data()?['name'] ?? 'Unknown User';

      final booking = {
        'userId': user.uid,
        'providerId': providerId,
        'serviceId': service.id,
        'userName': userName,
        'userPhone': userPhone,
        'providerName': providerName,
        'serviceName': service.name,
        'scheduledDate': Timestamp.fromDate(dateTime),
        'scheduledTime': Timestamp.fromDate(dateTime),
        'totalAmount': service.price,
        'status': 'pending',
        'createdAt': Timestamp.now(),
        'address': address,
        'notes': notes ?? '',
        'userLocation': userLocation ?? {},
      };

      final docRef = await _db.collection(collection).add(booking);

      // Send notification to provider
      await _sendNotificationToProvider(
          providerId, 'New booking request from $userName');

      return docRef.id;
    } catch (e) {
      print('Error creating booking: $e');
      return null;
    }
  }

  // Get user bookings
  static Stream<List<BookingModel>> getUserBookings(String userId) {
    return _db
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get provider bookings
  static Stream<List<BookingModel>> getProviderBookings(String providerId) {
    return _db
        .collection(collection)
        .where('providerId', isEqualTo: providerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get all bookings (admin only)
  static Stream<List<BookingModel>> getAllBookings() {
    return _db
        .collection(collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Update booking status (admin or provider)
  static Future<bool> updateBookingStatus(String bookingId, String status,
      {String? reason}) async {
    try {
      final updates = <String, dynamic>{
        'status': status,
        'updatedAt': Timestamp.now(),
      };

      if (status == 'completed') {
        updates['completedAt'] = Timestamp.now();
      }

      if (reason != null && (status == 'cancelled' || status == 'rejected')) {
        updates['cancellationReason'] = reason;
      }

      await _db.collection(collection).doc(bookingId).update(updates);

      // Get booking details for notification
      final bookingDoc = await _db.collection(collection).doc(bookingId).get();
      if (bookingDoc.exists) {
        final bookingData = bookingDoc.data()!;
        final userId = bookingData['userId'];
        final serviceName = bookingData['serviceName'];

        // Send notification to user
        await _sendNotificationToUser(
            userId, 'Your booking for $serviceName has been $status');
      }

      return true;
    } catch (e) {
      print('Error updating booking status: $e');
      return false;
    }
  }

  // Cancel booking (user)
  static Future<bool> cancelBooking(String bookingId, String reason) async {
    return await updateBookingStatus(bookingId, 'cancelled', reason: reason);
  }

  // Get booking by ID
  static Future<BookingModel?> getBooking(String bookingId) async {
    try {
      final doc = await _db.collection(collection).doc(bookingId).get();
      if (doc.exists) {
        return BookingModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting booking: $e');
      return null;
    }
  }

  // Get booking statistics
  static Future<Map<String, int>> getBookingStats() async {
    try {
      final snapshot = await _db.collection(collection).get();
      final stats = <String, int>{
        'total': 0,
        'pending': 0,
        'confirmed': 0,
        'inProgress': 0,
        'completed': 0,
        'cancelled': 0,
        'rejected': 0,
      };

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'pending';
        stats['total'] = (stats['total'] ?? 0) + 1;
        stats[status] = (stats[status] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      print('Error getting booking stats: $e');
      return {};
    }
  }

  // Send notification to provider
  static Future<void> _sendNotificationToProvider(
      String providerId, String message) async {
    try {
      await _db.collection('notifications').add({
        'userId': providerId,
        'title': 'New Booking Request',
        'message': message,
        'type': 'booking',
        'isRead': false,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error sending notification to provider: $e');
    }
  }

  // Send notification to user
  static Future<void> _sendNotificationToUser(
      String userId, String message) async {
    try {
      await _db.collection('notifications').add({
        'userId': userId,
        'title': 'Booking Update',
        'message': message,
        'type': 'booking_update',
        'isRead': false,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error sending notification to user: $e');
    }
  }
}
