import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/unified_service_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ServiceModel>> getServices() async {
    var snapshot = await _db.collection('services').get();
    return snapshot.docs
        .map((doc) => ServiceModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> bookService(String userId, String serviceId,
      DateTime bookingDate, String note) async {
    var bookingRef =
        _db.collection('users').doc(userId).collection('bookings').doc();
    await bookingRef.set({
      'serviceId': serviceId,
      'bookingDate': bookingDate,
      'status': 'Pending',
      'bookingId': bookingRef.id,
      'userNote': note,
    });
  }

  Stream<List<Map<String, dynamic>>> getUserBookingsStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .orderBy('bookingDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  ...doc.data(),
                  'bookingId': doc.id,
                })
            .toList());
  }
}
