import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../providers/booking_provider.dart';
import 'package:provider/provider.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsScreen({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(booking.service.imageUrl),
                ),
                title: Text(
                  booking.service.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  'Status: ${booking.status}',
                  style: TextStyle(
                    color: _getStatusColor(booking.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoSection(
              context,
              'Booking Information',
              [
                _buildInfoRow('Date', _formatDate(booking.dateTime)),
                _buildInfoRow('Time', _formatTime(booking.dateTime)),
                _buildInfoRow(
                  'Total Amount',
                  '\$${booking.totalAmount.toStringAsFixed(2)}',
                ),
                if (booking.notes != null && booking.notes!.isNotEmpty)
                  _buildInfoRow('Notes', booking.notes!),
              ],
            ),
            const SizedBox(height: 16),
            if (booking.status == 'upcoming')
              ElevatedButton(
                onPressed: () => _cancelBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Cancel Booking'),
              ),
            if (booking.status == 'completed' && booking.rating == null)
              ElevatedButton(
                onPressed: () => _showRatingDialog(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Rate Service'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _cancelBooking(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await context.read<BookingProvider>().cancelBooking(booking.id);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking cancelled successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _showRatingDialog(BuildContext context) async {
    double rating = 0;
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How would you rate this service?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    rating = index + 1.0;
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Review (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: rating == 0
                ? null
                : () async {
                    try {
                      await context.read<BookingProvider>().rateBooking(
                            booking.id,
                            rating,
                            controller.text,
                          );
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rating submitted successfully'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                          ),
                        );
                      }
                    }
                  },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
