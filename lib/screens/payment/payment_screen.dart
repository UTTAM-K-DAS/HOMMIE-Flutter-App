import 'package:flutter/material.dart';
import '../../models/unified_service_model.dart';

class PaymentScreen extends StatefulWidget {
  final ServiceModel service;
  final Map<String, dynamic> provider;
  final Map<String, dynamic> booking;

  const PaymentScreen({
    Key? key,
    required this.service,
    required this.provider,
    required this.booking,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildOrderSummary(),
            _buildPaymentMethods(),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildPriceRow(
            'Service Charge',
            widget.booking['price'].toString(),
          ),
          _buildPriceRow(
            'Service Fee',
            '20',
          ),
          _buildPriceRow(
            'Discount (FIRST20)',
            '-60',
            isDiscount: true,
          ),
          Divider(height: 32),
          _buildPriceRow(
            'Total Amount',
            (widget.booking['price'] + 20 - 60).toString(),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : null,
            ),
          ),
          Text(
            'TK $amount',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount
                  ? Colors.green
                  : isTotal
                      ? Theme.of(context).primaryColor
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildPaymentOption(
            'card',
            'Credit/Debit Card',
            '💳',
          ),
          _buildPaymentOption(
            'upi',
            'UPI Payment',
            '📱',
          ),
          _buildPaymentOption(
            'netbanking',
            'Net Banking',
            '🏦',
          ),
          _buildPaymentOption(
            'cash',
            'Cash on Service',
            '💰',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String id, String title, String emoji) {
    bool isSelected = _selectedPaymentMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).primaryColor.withAlpha(26)
              : Colors.white,
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _processPayment() async {
    switch (_selectedPaymentMethod) {
      case 'card':
        // Simulate card payment processing
        await Future.delayed(Duration(seconds: 1));
        return true;
      case 'upi':
        // Simulate UPI payment processing
        await Future.delayed(Duration(milliseconds: 800));
        return true;
      case 'netbanking':
        // Simulate net banking payment processing
        await Future.delayed(Duration(seconds: 1));
        return true;
      case 'cash':
        // No processing needed for cash payment
        return true;
      default:
        return false;
    }
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );

          try {
            // Simulate payment processing
            await Future.delayed(Duration(seconds: 2));

            // Process payment based on selected method
            bool paymentSuccess = await _processPayment();

            // Remove loading indicator
            Navigator.pop(context);

            if (paymentSuccess) {
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Payment successful!'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                ),
              );

              // Navigate to confirmation screen
              Navigator.pushReplacementNamed(
                context,
                '/confirmation',
                arguments: {
                  'service': widget.service,
                  'provider': widget.provider,
                  'booking': {
                    ...widget.booking,
                    'paymentStatus': 'completed',
                    'paymentMethod': _selectedPaymentMethod,
                    'paymentId': 'PAY-${DateTime.now().millisecondsSinceEpoch}',
                  },
                  'paymentMethod': _selectedPaymentMethod,
                },
              );
            } else {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Payment failed. Please try again.'),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } catch (e) {
            // Remove loading indicator
            Navigator.pop(context);

            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An error occurred. Please try again later.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(
          'Pay ৳${(widget.booking['price'] + 20 - 60)} & Confirm Booking',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
