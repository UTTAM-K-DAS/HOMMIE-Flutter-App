import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'bookings';

  // Get all bookings
  Stream<List<BookingModel>> getBookings() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get bookings by status
  Stream<List<BookingModel>> getBookingsByStatus(String status) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get single booking
  Future<BookingModel?> getBooking(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return BookingModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Update booking status
  Future<void> updateBookingStatus(String id, String status) async {
    await _firestore.collection(_collection).doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Assign provider to booking
  Future<void> assignProvider(String bookingId, String providerId) async {
    await _firestore.collection(_collection).doc(bookingId).update({
      'providerId': providerId,
      'status': 'assigned',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get bookings by provider
  Stream<List<BookingModel>> getBookingsByProvider(String providerId) {
    return _firestore
        .collection(_collection)
        .where('providerId', isEqualTo: providerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get bookings by customer
  Stream<List<BookingModel>> getBookingsByCustomer(String customerId) {
    return _firestore
        .collection(_collection)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Delete booking
  Future<void> deleteBooking(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Get booking statistics
  Future<Map<String, int>> getBookingStats() async {
    final pendingQuery = await _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'pending')
        .get();

    final completedQuery = await _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'completed')
        .get();

    final cancelledQuery = await _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'cancelled')
        .get();

    return {
      'pending': pendingQuery.docs.length,
      'completed': completedQuery.docs.length,
      'cancelled': cancelledQuery.docs.length,
      'total':
          pendingQuery.docs.length +
          completedQuery.docs.length +
          cancelledQuery.docs.length,
    };
  }
}
