import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';
import '../models/unified_service_model.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
      print('Error getting booking: $e');
      return null;
    }
  }
}
