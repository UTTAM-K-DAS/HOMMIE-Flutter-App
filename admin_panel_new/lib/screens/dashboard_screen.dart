import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/sidebar.dart';
import '../services/booking_service.dart';
import '../services/user_management_service.dart';
import '../debug/admin_debug_widget.dart';
import 'provider_management_screen.dart';
import 'provider_management_detailed_screen.dart' as detailed;
import 'service_management_screen.dart';
import 'booking_management_screen.dart';
import 'user_management_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final BookingService _bookingService = BookingService();
  final UserManagementService _userService = UserManagementService();

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return const ProviderManagementScreen();
      case 2:
        return const ServiceManagementScreen();
      case 3:
        return const BookingManagementScreen();
      case 4:
        return const UserManagementScreen();
      case 5:
        _logout();
        return const SizedBox.shrink();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  Widget _buildDashboardContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Refresh dashboard data
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Text(
              'Welcome back, Admin!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Here\'s what\'s happening with your business today.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Statistics Cards
            _buildStatisticsCards(),

            const SizedBox(height: 32),

            // Debug Panel
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Debug Panel',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AdminStatusDebug(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                detailed.DetailedProviderManagementScreen(),
                          ),
                        );
                      },
                      child: const Text('Enhanced Provider Management'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Recent Activities Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent Bookings
                Expanded(child: _buildRecentBookings()),
                const SizedBox(width: 24),
                // Quick Actions
                SizedBox(width: 300, child: _buildQuickActions()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadDashboardStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data ?? {};
        final bookingStats = stats['bookings'] ?? {};
        final userStats = stats['users'] ?? {};

        return GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              'Total Bookings',
              bookingStats['total']?.toString() ?? '0',
              Icons.calendar_today,
              Colors.blue,
            ),
            _buildStatCard(
              'Pending Bookings',
              bookingStats['pending']?.toString() ?? '0',
              Icons.schedule,
              Colors.orange,
            ),
            _buildStatCard(
              'Total Users',
              userStats['totalUsers']?.toString() ?? '0',
              Icons.people,
              Colors.green,
            ),
            _buildStatCard(
              'Active Providers',
              userStats['providers']?.toString() ?? '0',
              Icons.work,
              Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            FittedBox(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                title,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookings() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Bookings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3; // Bookings page
                    });
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: StreamBuilder(
                stream: _bookingService.getBookings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final bookings = snapshot.data ?? [];
                  final recentBookings = bookings.take(5).toList();

                  if (recentBookings.isEmpty) {
                    return const Center(child: Text('No recent bookings'));
                  }

                  return ListView.builder(
                    itemCount: recentBookings.length,
                    itemBuilder: (context, index) {
                      final booking = recentBookings[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(booking.status),
                          child: Icon(
                            _getStatusIcon(booking.status),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(booking.service.name),
                        subtitle: Text('Customer: ${booking.userId}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '\$${booking.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              booking.status,
                              style: TextStyle(
                                color: _getStatusColor(booking.status),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildQuickActionButton(
              'Manage Providers',
              Icons.people_alt,
              Colors.orange,
              () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildQuickActionButton(
              'Manage Services',
              Icons.room_service,
              Colors.blue,
              () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildQuickActionButton(
              'View Bookings',
              Icons.calendar_month,
              Colors.green,
              () {
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildQuickActionButton(
              'Manage Users',
              Icons.supervisor_account,
              Colors.purple,
              () {
                setState(() {
                  _selectedIndex = 4;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Icon(icon), const SizedBox(width: 12), Text(title)],
        ),
      ),
    );
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

  Future<Map<String, dynamic>> _loadDashboardStats() async {
    try {
      final bookingStats = await _bookingService.getBookingStats();
      final userStats = await _userService.getUserStats();

      return {'bookings': bookingStats, 'users': userStats};
    } catch (e) {
      developer.log(
        'Error loading dashboard stats: $e',
        name: 'DashboardScreen',
      );
      return {};
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onSelect: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(child: _getScreen(_selectedIndex)),
        ],
      ),
    );
  }
}
