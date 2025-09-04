import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final String _baseUrl = 'https://checkout.pay.bka.sh/v1.2.0-beta';
  final String _username; // Your bKash username
  final String _password; // Your bKash password
  final String _appKey; // Your bKash app key
  final String _appSecret; // Your bKash app secret
  String? _accessToken;

  PaymentService({
    required String username,
    required String password,
    required String appKey,
    required String appSecret,
  })  : _username = username,
        _password = password,
        _appKey = appKey,
        _appSecret = appSecret;

  Future<void> _grantToken() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/checkout/token/grant'),
      headers: {
        'username': _username,
        'password': _password,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'app_key': _appKey,
        'app_secret': _appSecret,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['id_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<Map<String, dynamic>> createPayment({
    required String amount,
    required String merchantInvoiceNumber,
    required String callbackURL,
  }) async {
    if (_accessToken == null) {
      await _grantToken();
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/checkout/payment/create'),
      headers: {
        'Authorization': _accessToken!,
        'X-APP-Key': _appKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'amount': amount,
        'currency': 'BDT',
        'merchantInvoiceNumber': merchantInvoiceNumber,
        'callbackURL': callbackURL,
        'intent': 'sale',
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create payment');
    }
  }

  Future<Map<String, dynamic>> executePayment(String paymentID) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/checkout/payment/execute/$paymentID'),
      headers: {
        'Authorization': _accessToken!,
        'X-APP-Key': _appKey,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to execute payment');
    }
  }

  Future<Map<String, dynamic>> queryPayment(String paymentID) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/checkout/payment/query/$paymentID'),
      headers: {
        'Authorization': _accessToken!,
        'X-APP-Key': _appKey,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to query payment');
    }
  }

  Future<void> processPayment({
    required String amount,
    required String invoiceNumber,
    required Function(String paymentURL) onPaymentURLReceived,
    required Function(Map<String, dynamic> result) onPaymentSuccess,
    required Function(String error) onPaymentError,
  }) async {
    try {
      // 1. Create payment
      final createResponse = await createPayment(
        amount: amount,
        merchantInvoiceNumber: invoiceNumber,
        callbackURL: 'your_app_scheme://payment',
      );

      final paymentID = createResponse['paymentID'];
      final paymentURL = createResponse['bkashURL'];

      // 2. Send payment URL to UI
      onPaymentURLReceived(paymentURL);

      // 3. Execute payment after user completes the payment
      final executeResponse = await executePayment(paymentID);

      if (executeResponse['statusCode'] == '0000') {
        // Payment successful
        onPaymentSuccess(executeResponse);
      } else {
        onPaymentError(executeResponse['statusMessage']);
      }
    } catch (e) {
      onPaymentError(e.toString());
    }
  }
}
