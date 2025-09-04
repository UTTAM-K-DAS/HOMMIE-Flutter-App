import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String bookingId = '';
  String serviceName = '';
  String providerName = 'Ahmed Hassan';
  String providerPhone = '+880 1712-345678';
  String estimatedTime = '15-20 minutes';
  double rating = 4.8;

  Timer? locationTimer;
  String status = 'On the way';
  int progressValue = 65;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments from route
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      bookingId = args['bookingId'] ?? '';
      serviceName = args['serviceName'] ?? 'Home Service';
    }

    _startLocationTracking();
  }

  @override
  void dispose() {
    locationTimer?.cancel();
    super.dispose();
  }

  void _startLocationTracking() {
    // Simulate real-time location updates
    locationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        // Simulate provider getting closer
        if (progressValue < 100) {
          progressValue += Random().nextInt(5) + 2;
          if (progressValue > 100) progressValue = 100;

          if (progressValue >= 100) {
            status = 'Arrived';
            estimatedTime = 'Provider has arrived';
            timer.cancel();
          } else if (progressValue >= 90) {
            status = 'Very close';
            estimatedTime = '2-3 minutes';
          } else if (progressValue >= 80) {
            status = 'Nearby';
            estimatedTime = '5-8 minutes';
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Service Provider'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // Simulate refresh
              _showSnackBar('Location updated');
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor(),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.access_time,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          estimatedTime,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: progressValue / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(_getStatusColor()),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$progressValue% complete',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Map Placeholder with animated markers
            Card(
              elevation: 2,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Map background pattern
                    CustomPaint(
                      size: const Size(double.infinity, 250),
                      painter: MapPatternPainter(),
                    ),

                    // User location marker
                    const Positioned(
                      top: 180,
                      right: 80,
                      child: Column(
                        children: [
                          Chip(
                            label: Text(
                              'You',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.green,
                          ),
                          Icon(Icons.location_on,
                              color: Colors.green, size: 24),
                        ],
                      ),
                    ),

                    // Provider location marker (animated position)
                    AnimatedPositioned(
                      duration: const Duration(seconds: 2),
                      top: progressValue >= 90 ? 160 : 80,
                      left: progressValue >= 90 ? 140 : 100,
                      child: Column(
                        children: [
                          Chip(
                            label: const Text(
                              'Provider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          Icon(
                            Icons.person_pin_circle,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    // Route line
                    CustomPaint(
                      size: const Size(double.infinity, 250),
                      painter: RoutePainter(Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Provider Details Card
            ProviderInfoCard(
              providerName: providerName,
              providerImage: '',
              rating: rating.toString(),
              phone: providerPhone,
              serviceName: serviceName,
              onCall: _makePhoneCall,
            ),

            const SizedBox(height: 16),

            // Journey Steps Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Journey Progress',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildJourneyStep(
                      'Booking Confirmed',
                      'Service provider assigned',
                      Icons.check_circle,
                      Colors.green,
                      true,
                    ),
                    _buildJourneyStep(
                      'Provider Departed',
                      'On the way to your location',
                      Icons.directions_car,
                      progressValue >= 50 ? Colors.green : Colors.grey,
                      progressValue >= 50,
                    ),
                    _buildJourneyStep(
                      'Service Started',
                      'Provider will start the service',
                      Icons.build,
                      progressValue >= 100 ? Colors.green : Colors.grey,
                      progressValue >= 100,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/chat',
                        arguments: {
                          'providerId': 'provider_1',
                          'bookingId': bookingId
                        },
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Chat'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _cancelBooking(),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyStep(String title, String subtitle, IconData icon,
      Color color, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? Colors.black : Colors.grey[600],
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted) Icon(Icons.check, color: color, size: 16),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case 'Arrived':
        return Colors.green;
      case 'Very close':
      case 'Nearby':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _makePhoneCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Provider'),
        content: Text('Do you want to call $providerName at $providerPhone?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Calling $providerPhone...');
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _cancelBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              _showSnackBar('Booking cancelled successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class ProviderInfoCard extends StatelessWidget {
  final String providerName;
  final String providerImage;
  final String rating;
  final String phone;
  final String serviceName;
  final VoidCallback onCall;

  const ProviderInfoCard({
    Key? key,
    required this.providerName,
    required this.providerImage,
    required this.rating,
    required this.phone,
    required this.serviceName,
    required this.onCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Provider',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber[600],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• $serviceName',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onCall,
                  icon: const Icon(Icons.phone),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green[100],
                    foregroundColor: Colors.green[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw grid pattern to simulate map
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoutePainter extends CustomPainter {
  final Color color;

  RoutePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(100, 80); // Provider position
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.4, size.width - 80,
        180); // User position

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
