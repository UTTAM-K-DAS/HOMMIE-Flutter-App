import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../providers/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingScreen extends StatelessWidget {
  final String bookingId;

  const TrackingScreen({
    Key? key,
    required this.bookingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Service'),
      ),
      body: StreamBuilder<BookingModel?>(
        stream: context.read<BookingProvider>().trackBooking(bookingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final booking = snapshot.data;
          if (booking == null) {
            return const Center(
              child: Text('Booking not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceInfo(booking),
                const SizedBox(height: 30),
                _buildStatusTimeline(booking),
                if (booking.status.toLowerCase() == 'in_progress')
                  _buildProviderInfo(booking),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceInfo(BookingModel booking) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(booking.service.imageUrl),
        ),
        title: Text(booking.service.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Booking ID: ${booking.id}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Date: ${_formatDate(booking.dateTime)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Text(
          booking.status,
          style: TextStyle(
            color: _getStatusColor(booking.status),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(BookingModel booking) {
    final statuses = [
      'Pending',
      'Confirmed',
      'In Progress',
      'Completed',
    ];

    final currentIndex = statuses.indexWhere(
      (status) => status.toLowerCase() == booking.status.toLowerCase(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: Column(
            children: List.generate(
              statuses.length,
              (index) => _buildTimelineTile(
                isFirst: index == 0,
                isLast: index == statuses.length - 1,
                status: statuses[index],
                time: _getStatusTime(booking, statuses[index]),
                isActive: index <= currentIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineTile({
    required bool isFirst,
    required bool isLast,
    required String status,
    required String? time,
    required bool isActive,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isActive ? Colors.blue : Colors.grey.shade300,
      ),
      indicatorStyle: IndicatorStyle(
        width: 25,
        color: isActive ? Colors.blue : Colors.grey.shade300,
        iconStyle: IconStyle(
          color: Colors.white,
          iconData: Icons.check,
        ),
      ),
      endChild: Container(
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (time != null)
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderInfo(BookingModel booking) {
    // Only show if provider details are available
    if (booking.extras == null ||
        !booking.extras!.containsKey('providerDetails')) {
      return SizedBox.shrink();
    }

    final providerDetails = booking.extras!['providerDetails'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          'Service Provider',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(providerDetails['imageUrl'] ?? ''),
              child: providerDetails['imageUrl'] == null
                  ? Text(providerDetails['name'][0])
                  : null,
            ),
            title: Text(providerDetails['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(' ${providerDetails['rating']} • '),
                    Text('${providerDetails['experience']} years exp'),
                  ],
                ),
                if (providerDetails['phone'] != null)
                  TextButton.icon(
                    onPressed: () async {
                      final phoneNumber = providerDetails['phone'];
                      if (phoneNumber != null) {
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: phoneNumber,
                        );
                        try {
                          if (await canLaunchUrl(launchUri)) {
                            await launchUrl(launchUri);
                          } else {
                            throw 'Could not launch phone call';
                          }
                        } catch (e) {
                          debugPrint('Error launching phone call: $e');
                        }
                      }
                    },
                    icon: Icon(Icons.phone),
                    label: Text('Call Provider'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'in_progress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String? _getStatusTime(BookingModel booking, String status) {
    // In a real app, you would store timestamps for each status change
    // For now, we'll just show the booking time for the current status
    if (status.toLowerCase() == booking.status.toLowerCase()) {
      return _formatDateTime(booking.updatedAt ?? booking.createdAt);
    }
    return null;
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
