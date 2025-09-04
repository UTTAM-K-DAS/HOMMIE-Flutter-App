import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> booking;

  const PaymentScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String _selectedMethod = 'cash';
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cash',
      'name': 'Cash on Service',
      'icon': Icons.money,
      'description': 'Pay when service is completed'
    },
    {
      'id': 'bkash',
      'name': 'bKash',
      'icon': Icons.phone_android,
      'description': 'Pay via bKash mobile banking'
    },
    {
      'id': 'nagad',
      'name': 'Nagad',
      'icon': Icons.phone_android,
      'description': 'Pay via Nagad mobile banking'
    },
    {
      'id': 'rocket',
      'name': 'Rocket',
      'icon': Icons.phone_android,
      'description': 'Pay via Rocket mobile banking'
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'description': 'Pay with your card'
    },
  ];

  // Extract booking data from the passed arguments
  String get serviceName => widget.booking['service']?.name ?? 'Service';
  DateTime get bookingDateTime => widget.booking['dateTime'] ?? DateTime.now();
  double get totalAmount => widget.booking['totalAmount'] ?? 0.0;
  String get bookingId =>
      widget.booking['bookingId'] ??
      DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order summary card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    _buildSummaryRow('Service', serviceName),
                    _buildSummaryRow('Date', _formatDate(bookingDateTime)),
                    _buildSummaryRow('Time', _formatTime(bookingDateTime)),
                    _buildSummaryRow('Booking ID', bookingId),
                    const Divider(height: 30),
                    _buildSummaryRow(
                      'Total Amount',
                      '৳${totalAmount.toStringAsFixed(0)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Payment methods
            Text(
              'Choose Payment Method',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Payment method cards
            ..._paymentMethods.map((method) => _buildPaymentMethodCard(method)),

            const SizedBox(height: 24),

            // Card form for card payment
            if (_selectedMethod == 'card') ...[
              _buildCardForm(),
              const SizedBox(height: 24),
            ],

            // Mobile banking form
            if (['bkash', 'nagad', 'rocket'].contains(_selectedMethod)) ...[
              _buildMobileBankingForm(),
              const SizedBox(height: 24),
            ],

            // Confirm button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Processing...'),
                        ],
                      )
                    : Text(
                        'Confirm Payment - ৳${totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Payment info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getPaymentInfo(),
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.black : Colors.grey[600],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 15,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 18 : 15,
              color: isTotal ? Theme.of(context).primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedMethod == method['id'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        onTap: () {
          setState(() => _selectedMethod = method['id']);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: method['id'],
                groupValue: _selectedMethod,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedMethod = value);
                  }
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  method['icon'],
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method['description'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileBankingForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_selectedMethod.toUpperCase()} Payment',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                hintText: '01XXXXXXXXX',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'PIN',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.lock),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  String _getPaymentInfo() {
    switch (_selectedMethod) {
      case 'cash':
        return 'You will pay the service provider in cash when the service is completed.';
      case 'bkash':
      case 'nagad':
      case 'rocket':
        return 'You will be redirected to ${_selectedMethod.toUpperCase()} to complete the payment.';
      case 'card':
        return 'Your payment will be processed securely through our payment gateway.';
      default:
        return 'Complete your payment to confirm the booking.';
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    try {
      // In a real app, this would call your payment API
      final success = await _simulatePayment();

      if (!mounted) return;

      if (success) {
        // Navigate to confirmation screen
        Navigator.pushReplacementNamed(
          context,
          '/confirmation',
          arguments: {
            'bookingId': bookingId,
            'serviceName': serviceName,
            'amount': totalAmount,
            'paymentMethod': _selectedMethod,
            'dateTime': bookingDateTime,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<bool> _simulatePayment() async {
    // Simulate different success rates for different payment methods
    switch (_selectedMethod) {
      case 'cash':
        return true; // Cash payments always "succeed"
      case 'bkash':
      case 'nagad':
      case 'rocket':
        return DateTime.now().millisecond % 10 != 0; // 90% success rate
      case 'card':
        return DateTime.now().millisecond % 5 != 0; // 80% success rate
      default:
        return true;
    }
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]}, ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : hour;
    return '$displayHour:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }
}
