import 'package:flutter/material.dart';

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Service Status', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        TimelineStatus(
          title: 'Booking Confirmed',
          time: '10:30 AM',
          isCompleted: true,
        ),
        TimelineStatus(
          title: 'Provider Assigned',
          time: '10:35 AM',
          isCompleted: true,
        ),
        TimelineStatus(
          title: 'On the way',
          time: '10:40 AM',
          isActive: true,
        ),
        TimelineStatus(
          title: 'Service Started',
          time: 'Pending',
          isCompleted: false,
        ),
        TimelineStatus(
          title: 'Service Completed',
          time: 'Pending',
          isCompleted: false,
          showLine: false,
        ),
      ],
    );
  }
}

class TimelineStatus extends StatelessWidget {
  final String title;
  final String time;
  final bool isCompleted;
  final bool isActive;
  final bool showLine;

  const TimelineStatus({
    Key? key,
    required this.title,
    required this.time,
    this.isCompleted = false,
    this.isActive = false,
    this.showLine = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            if (showLine)
              Container(
                width: 2,
                height: 30,
                color: isCompleted
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
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
      ],
    );
  }
}
