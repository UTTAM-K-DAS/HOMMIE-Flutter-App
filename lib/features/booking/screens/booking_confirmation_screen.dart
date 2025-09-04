import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;

  const BookingConfirmationScreen({
    Key? key,
    required this.bookingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract booking data from route arguments if available
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final serviceName = args?['serviceName'] ?? 'Service';
    final amount = args?['amount'] ?? 0.0;
    final paymentMethod = args?['paymentMethod'] ?? 'cash';
    final dateTime = args?['dateTime'] ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        automaticallyImplyLeading: false,
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
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success Animation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: 80,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Booking Confirmed!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
            ),

            const SizedBox(height: 12),

            Text(
              'Your service has been successfully booked',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Booking Details Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow('Booking ID', bookingId),
                    _buildDetailRow('Service', serviceName.toString()),
                    _buildDetailRow('Date', _formatDate(dateTime)),
                    _buildDetailRow('Time', _formatTime(dateTime)),
                    _buildDetailRow('Payment Method',
                        _getPaymentMethodName(paymentMethod.toString())),
                    const Divider(height: 24),
                    _buildDetailRow(
                      'Total Amount',
                      '৳${amount.toString()}',
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // What's Next Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'What\'s Next?',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStepRow(
                      '1',
                      'Service Provider Assignment',
                      'We\'ll assign the best service provider for your needs',
                    ),
                    const SizedBox(height: 12),
                    _buildStepRow(
                      '2',
                      'Provider Contact',
                      'The assigned provider will contact you shortly',
                    ),
                    const SizedBox(height: 12),
                    _buildStepRow(
                      '3',
                      'Service Completion',
                      'Your service will be completed at the scheduled time',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/tracking',
                        arguments: {'bookingId': bookingId},
                      );
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('Track Service Provider'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/bookings',
                        (route) => route.settings.name == '/',
                      );
                    },
                    icon: const Icon(Icons.list_alt),
                    label: const Text('View All Bookings'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  },
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isHighlighted ? Colors.black : Colors.grey[600],
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isHighlighted ? Colors.green[700] : Colors.black,
              fontSize: isHighlighted ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
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

  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'cash':
        return 'Cash on Service';
      case 'bkash':
        return 'bKash';
      case 'nagad':
        return 'Nagad';
      case 'rocket':
        return 'Rocket';
      case 'card':
        return 'Credit/Debit Card';
      default:
        return method.toUpperCase();
    }
  }
}
