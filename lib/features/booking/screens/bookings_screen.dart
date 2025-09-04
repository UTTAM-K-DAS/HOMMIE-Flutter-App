import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample booking data
  final List<BookingItem> _activeBookings = [
    BookingItem(
      id: 'BK001',
      serviceName: 'AC Servicing',
      providerName: 'Ahmed Hassan',
      amount: 599.0,
      date: DateTime.now().add(const Duration(hours: 2)),
      status: 'Confirmed',
      imageIcon: Icons.ac_unit,
      statusColor: Colors.green,
    ),
    BookingItem(
      id: 'BK002',
      serviceName: 'Home Cleaning',
      providerName: 'Fatima Rahman',
      amount: 299.0,
      date: DateTime.now().add(const Duration(days: 1)),
      status: 'Pending',
      imageIcon: Icons.cleaning_services,
      statusColor: Colors.orange,
    ),
  ];

  final List<BookingItem> _completedBookings = [
    BookingItem(
      id: 'BK003',
      serviceName: 'Plumbing',
      providerName: 'Mohammad Ali',
      amount: 450.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Completed',
      imageIcon: Icons.plumbing,
      statusColor: Colors.green,
    ),
    BookingItem(
      id: 'BK004',
      serviceName: 'Electrical Work',
      providerName: 'Karim Sheikh',
      amount: 350.0,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Completed',
      imageIcon: Icons.electrical_services,
      statusColor: Colors.green,
    ),
    BookingItem(
      id: 'BK005',
      serviceName: 'Beauty & Salon',
      providerName: 'Nasreen Beauty',
      amount: 299.0,
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: 'Completed',
      imageIcon: Icons.face,
      statusColor: Colors.green,
    ),
  ];

  final List<BookingItem> _cancelledBookings = [
    BookingItem(
      id: 'BK006',
      serviceName: 'House Shifting',
      providerName: 'Move Masters',
      amount: 2499.0,
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'Cancelled',
      imageIcon: Icons.local_shipping,
      statusColor: Colors.red,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(_activeBookings, 'active'),
          _buildBookingsList(_completedBookings, 'completed'),
          _buildBookingsList(_cancelledBookings, 'cancelled'),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<BookingItem> bookings, String type) {
    if (bookings.isEmpty) {
      return _buildEmptyState(type);
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookings refreshed')),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return BookingCard(
            booking: bookings[index],
            onTap: () => _showBookingDetails(bookings[index]),
            onTrack:
                type == 'active' ? () => _trackBooking(bookings[index]) : null,
            onCancel: type == 'active' && bookings[index].status != 'Cancelled'
                ? () => _cancelBooking(bookings[index])
                : null,
            onRebook: type == 'completed' || type == 'cancelled'
                ? () => _rebookService(bookings[index])
                : null,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    String title, subtitle;
    IconData icon;

    switch (type) {
      case 'active':
        title = 'No Active Bookings';
        subtitle = 'Book a service to see it here';
        icon = Icons.calendar_today;
        break;
      case 'completed':
        title = 'No Completed Services';
        subtitle = 'Your completed services will appear here';
        icon = Icons.check_circle_outline;
        break;
      case 'cancelled':
        title = 'No Cancelled Bookings';
        subtitle = 'Your cancelled bookings will appear here';
        icon = Icons.cancel_outlined;
        break;
      default:
        title = 'No Bookings';
        subtitle = 'Start booking services';
        icon = Icons.list_alt;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
            child: const Text('Book a Service'),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(BookingItem booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BookingDetailsModal(booking: booking),
    );
  }

  void _trackBooking(BookingItem booking) {
    Navigator.pushNamed(
      context,
      '/tracking',
      arguments: {
        'bookingId': booking.id,
        'serviceName': booking.serviceName,
      },
    );
  }

  void _cancelBooking(BookingItem booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content:
            Text('Are you sure you want to cancel "${booking.serviceName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _activeBookings.remove(booking);
                booking.status = 'Cancelled';
                booking.statusColor = Colors.red;
                _cancelledBookings.insert(0, booking);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancelled successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _rebookService(BookingItem booking) {
    Navigator.pushNamed(
      context,
      '/service-details',
      arguments: {
        'serviceName': booking.serviceName,
      },
    );
  }
}

class BookingItem {
  final String id;
  final String serviceName;
  final String providerName;
  final double amount;
  final DateTime date;
  String status;
  final IconData imageIcon;
  Color statusColor;

  BookingItem({
    required this.id,
    required this.serviceName,
    required this.providerName,
    required this.amount,
    required this.date,
    required this.status,
    required this.imageIcon,
    required this.statusColor,
  });
}

class BookingCard extends StatelessWidget {
  final BookingItem booking;
  final VoidCallback onTap;
  final VoidCallback? onTrack;
  final VoidCallback? onCancel;
  final VoidCallback? onRebook;

  const BookingCard({
    Key? key,
    required this.booking,
    required this.onTap,
    this.onTrack,
    this.onCancel,
    this.onRebook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      booking.imageIcon,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.serviceName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.providerName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(booking.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: booking.statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          booking.status,
                          style: TextStyle(
                            color: booking.statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '৳${booking.amount.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (onTrack != null || onCancel != null || onRebook != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (onTrack != null) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onTrack,
                          icon: const Icon(Icons.location_on, size: 16),
                          label: const Text('Track'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      if (onCancel != null) const SizedBox(width: 8),
                    ],
                    if (onCancel != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onCancel,
                          icon: const Icon(Icons.cancel, size: 16),
                          label: const Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    if (onRebook != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onRebook,
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Book Again'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      // Past date
      final daysDiff = now.difference(date).inDays;
      if (daysDiff == 0) {
        return 'Today at ${_formatTime(date)}';
      } else if (daysDiff == 1) {
        return 'Yesterday at ${_formatTime(date)}';
      } else {
        return '${_formatShortDate(date)} at ${_formatTime(date)}';
      }
    } else {
      // Future date
      final daysDiff = difference.inDays;
      if (daysDiff == 0) {
        return 'Today at ${_formatTime(date)}';
      } else if (daysDiff == 1) {
        return 'Tomorrow at ${_formatTime(date)}';
      } else {
        return '${_formatShortDate(date)} at ${_formatTime(date)}';
      }
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : hour;
    return '$displayHour:${date.minute.toString().padLeft(2, '0')} $period';
  }

  String _formatShortDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}';
  }
}

class BookingDetailsModal extends StatelessWidget {
  final BookingItem booking;

  const BookingDetailsModal({Key? key, required this.booking})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Details',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow('Booking ID', '#${booking.id}'),
                      _buildDetailRow('Service', booking.serviceName),
                      _buildDetailRow('Provider', booking.providerName),
                      _buildDetailRow(
                          'Date & Time', _formatFullDate(booking.date)),
                      _buildDetailRow('Status', booking.status,
                          statusColor: booking.statusColor),
                      const Divider(height: 24),
                      _buildDetailRow(
                          'Total Amount', '৳${booking.amount.toInt()}',
                          isHighlighted: true),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value,
      {Color? statusColor, bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: statusColor ??
                  (isHighlighted ? Colors.green[700] : Colors.black),
              fontSize: isHighlighted ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : hour;
    return '${date.day} ${months[date.month - 1]} ${date.year}, $displayHour:${date.minute.toString().padLeft(2, '0')} $period';
  }
}
