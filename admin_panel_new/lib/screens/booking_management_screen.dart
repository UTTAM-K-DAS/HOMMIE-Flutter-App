import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen>
    with SingleTickerProviderStateMixin {
  final BookingService _bookingService = BookingService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(null), // All bookings
          _buildBookingList('pending'),
          _buildBookingList('in_progress'),
          _buildBookingList('completed'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBookingStats,
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.analytics, color: Colors.white),
      ),
    );
  }

  Widget _buildBookingList(String? status) {
    return StreamBuilder<List<BookingModel>>(
      stream: status == null
          ? _bookingService.getBookings()
          : _bookingService.getBookingsByStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final bookings = snapshot.data ?? [];

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${status ?? ''} bookings found',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(booking.status),
                    child: Icon(
                      _getStatusIcon(booking.status),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    booking.service.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer ID: ${booking.userId}'),
                      Text('Date: ${_formatDateTime(booking.dateTime)}'),
                      Text(
                        'Amount: \$${booking.totalAmount.toStringAsFixed(2)}',
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            booking.status,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          booking.status.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(booking.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (booking.address != null) ...[
                            const Text(
                              'Address:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(booking.address!),
                            const SizedBox(height: 8),
                          ],
                          if (booking.notes != null) ...[
                            const Text(
                              'Notes:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(booking.notes!),
                            const SizedBox(height: 8),
                          ],
                          if (booking.rating != null) ...[
                            Row(
                              children: [
                                const Text(
                                  'Rating: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      index < booking.rating!.round()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' (${booking.rating!.toStringAsFixed(1)})',
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (booking.review != null) ...[
                            const Text(
                              'Review:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(booking.review!),
                            const SizedBox(height: 16),
                          ],
                          // Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _buildActionButtons(booking),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<Widget> _buildActionButtons(BookingModel booking) {
    List<Widget> buttons = [];

    switch (booking.status) {
      case 'pending':
        buttons.addAll([
          ElevatedButton.icon(
            onPressed: () => _updateBookingStatus(booking.id, 'confirmed'),
            icon: const Icon(Icons.check),
            label: const Text('Confirm'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          ElevatedButton.icon(
            onPressed: () => _updateBookingStatus(booking.id, 'cancelled'),
            icon: const Icon(Icons.cancel),
            label: const Text('Cancel'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ]);
        break;
      case 'confirmed':
        buttons.add(
          ElevatedButton.icon(
            onPressed: () => _updateBookingStatus(booking.id, 'in_progress'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        );
        break;
      case 'in_progress':
        buttons.add(
          ElevatedButton.icon(
            onPressed: () => _updateBookingStatus(booking.id, 'completed'),
            icon: const Icon(Icons.done),
            label: const Text('Complete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        );
        break;
    }

    buttons.add(
      ElevatedButton.icon(
        onPressed: () => _showBookingDetails(booking),
        icon: const Icon(Icons.info),
        label: const Text('Details'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
      ),
    );

    return buttons;
  }

  Color _getStatusColor(String status) {
    switch (status) {
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.work;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _updateBookingStatus(String bookingId, String status) async {
    try {
      await _bookingService.updateBookingStatus(bookingId, status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking status updated to $status')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating booking: $e')));
      }
    }
  }

  void _showBookingDetails(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Booking ID', booking.id),
              _buildDetailRow('Service', booking.service.name),
              _buildDetailRow('Customer ID', booking.userId),
              _buildDetailRow('Date & Time', _formatDateTime(booking.dateTime)),
              _buildDetailRow('Status', booking.status),
              _buildDetailRow(
                'Amount',
                '\$${booking.totalAmount.toStringAsFixed(2)}',
              ),
              if (booking.address != null)
                _buildDetailRow('Address', booking.address!),
              if (booking.notes != null)
                _buildDetailRow('Notes', booking.notes!),
              _buildDetailRow('Created At', _formatDateTime(booking.createdAt)),
              if (booking.updatedAt != null)
                _buildDetailRow(
                  'Updated At',
                  _formatDateTime(booking.updatedAt!),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showBookingStats() async {
    final stats = await _bookingService.getBookingStats();

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatRow('Total Bookings', stats['total'].toString()),
              _buildStatRow('Pending', stats['pending'].toString()),
              _buildStatRow('Completed', stats['completed'].toString()),
              _buildStatRow('Cancelled', stats['cancelled'].toString()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
