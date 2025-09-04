import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final PaymentService _paymentService = PaymentService();
  bool _isProcessing = false;
  String? _error;

  bool get isProcessing => _isProcessing;
  String? get error => _error;

  void _setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  Future<bool> processPayment({
    required String bookingId,
    required double amount,
    required String method,
  }) async {
    _setProcessing(true);
    try {
      // Process payment through the payment service
      final paymentResult = await _paymentService.processPayment(
        amount: amount,
        method: method,
      );

      // Update booking with payment details
      await _db.collection('bookings').doc(bookingId).update({
        'paymentStatus': paymentResult.success ? 'completed' : 'failed',
        'paymentDetails': {
          'method': method,
          'amount': amount,
          'transactionId': paymentResult.transactionId,
          'timestamp': FieldValue.serverTimestamp(),
        },
      });

      return paymentResult.success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  Future<Map<String, dynamic>?> getPaymentDetails(String bookingId) async {
    try {
      final doc = await _db.collection('bookings').doc(bookingId).get();
      if (!doc.exists) return null;
      return doc.data()?['paymentDetails'];
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
