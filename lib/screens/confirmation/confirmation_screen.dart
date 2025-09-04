import 'package:flutter/material.dart';
import '../../models/unified_service_model.dart';

class ConfirmationScreen extends StatelessWidget {
  final ServiceModel service;
  final Map<String, dynamic> provider;
  final Map<String, dynamic> booking;
  final String paymentMethod;

  const ConfirmationScreen({
    Key? key,
    required this.service,
    required this.provider,
    required this.booking,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmed'),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildConfirmationHeader(),
            _buildBookingDetails(),
            _buildNextSteps(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationHeader() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 48,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Booking Confirmed!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your service has been successfully booked',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
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
            'Booking Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildDetailRow('Booking ID:',
              '#FS${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}'),
          _buildDetailRow('Service:', service.name),
          _buildDetailRow('Provider:', provider['name']),
          _buildDetailRow(
              'Date & Time:', '${booking['date']} at ${booking['time']}'),
          _buildDetailRow('Amount Paid:', 'TK ${booking['price']}'),
          _buildDetailRow('Payment Method:', _getPaymentMethodName()),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextSteps() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
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
            'What\'s Next?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildStep(
            '1',
            'Your service provider will contact you 1 hour before the scheduled time',
          ),
          _buildStep(
            '2',
            'You can track your service provider\'s location in real-time',
          ),
          _buildStep(
            '3',
            'Payment will be processed after service completion',
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/tracking', arguments: {
                'service': service,
                'provider': provider,
                'booking': booking,
              });
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
              'Track Service Provider',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Theme.of(context).primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text(
              'Back to Home',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName() {
    switch (paymentMethod) {
      case 'card':
        return 'Credit/Debit Card';
      case 'upi':
        return 'UPI Payment';
      case 'netbanking':
        return 'Net Banking';
      case 'cash':
        return 'Cash on Service';
      default:
        return 'Unknown';
    }
  }
}
