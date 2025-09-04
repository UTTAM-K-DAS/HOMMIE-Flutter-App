import 'package:flutter/foundation.dart';

class PaymentProvider with ChangeNotifier {
  String _selectedMethod = 'Cash';
  bool _isProcessing = false;

  String get selectedMethod => _selectedMethod;
  bool get isProcessing => _isProcessing;

  void setPaymentMethod(String method) {
    _selectedMethod = method;
    notifyListeners();
  }

  Future<bool> processPayment(double amount) async {
    _isProcessing = true;
    notifyListeners();

    // Implement payment logic
    await Future.delayed(const Duration(seconds: 2));

    _isProcessing = false;
    notifyListeners();

    return true;
  }
}
