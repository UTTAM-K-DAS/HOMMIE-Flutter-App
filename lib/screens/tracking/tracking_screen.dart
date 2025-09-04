import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/unified_service_model.dart';

class TrackingScreen extends StatefulWidget {
  final String bookingId;
  final ServiceModel service;
  final Map<String, dynamic> provider;

  const TrackingScreen({
    Key? key,
    required this.bookingId,
    required this.service,
    required this.provider,
  }) : super(key: key);

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Future<void> _launchPhoneCall(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final List<Map<String, dynamic>> timeline = [
    {
      'title': 'Booking Confirmed',
      'status': 'completed',
      'time': '10:30 AM',
    },
    {
      'title': 'Provider Assigned',
      'status': 'completed',
      'time': '10:35 AM',
    },
    {
      'title': 'On the way',
      'status': 'current',
      'time': 'Current status',
    },
    {
      'title': 'Service in Progress',
      'status': 'pending',
      'time': 'Pending',
    },
    {
      'title': 'Service Completed',
      'status': 'pending',
      'time': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Service'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProviderCard(),
            _buildLocationMap(),
            _buildTimeline(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard() {
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
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  widget.provider['name'][0],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.provider['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Service: ${widget.service.name}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.phone, color: Colors.green),
                onPressed: () async {
                  final Uri telUri = Uri(
                    scheme: 'tel',
                    path:
                        '+1234567890', // Replace with actual provider phone number
                  );

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Call Service Provider'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Are you sure you want to call:'),
                          SizedBox(height: 8),
                          Text(
                            widget.provider['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            try {
                              await _launchPhoneCall(telUri);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Could not initiate call')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text('Call'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service provider is on the way',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Estimated arrival: 15 minutes (2.3 km away)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMap() {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 48, color: Colors.grey[400]),
            SizedBox(height: 8),
            Text(
              'Live Location Map',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
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
            'Service Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...timeline.map((step) => _buildTimelineStep(step)).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(Map<String, dynamic> step) {
    Color getStatusColor() {
      switch (step['status']) {
        case 'completed':
          return Colors.green;
        case 'current':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: getStatusColor(),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  step['time'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final Uri telUri = Uri(
                scheme: 'tel',
                path:
                    '+1234567890', // Replace with actual provider phone number
              );

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Call Service Provider'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Are you sure you want to call:'),
                      SizedBox(height: 8),
                      Text(
                        widget.provider['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          await _launchPhoneCall(telUri);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not initiate call')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Call'),
                    ),
                  ],
                ),
              );
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
              'Call Service Provider',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/support-chat',
                arguments: {
                  'bookingId': widget.bookingId,
                  'service': widget.service,
                  'provider': widget.provider,
                },
              );

              // Show feature coming soon message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Support chat feature coming soon!'),
                  action: SnackBarAction(
                    label: 'Call Support',
                    onPressed: () {
                      final Uri telUri = Uri(
                        scheme: 'tel',
                        path:
                            '+1234567890', // Replace with support phone number
                      );
                      _launchPhoneCall(telUri);
                    },
                  ),
                ),
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
              'Chat with Support',
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
}
