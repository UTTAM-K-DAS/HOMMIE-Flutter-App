import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFff6b35),
            const Color(0xFFf7931e),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Why Choose Us',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Because we care about your safety',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white
                      .withValues(red: 255, green: 255, blue: 255, alpha: 230),
                ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatItem(context, '15,000+', 'Service Providers'),
              _buildStatItem(context, '2,00,000+', 'Orders Served'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(context, '1,00,000+', '5 Star Reviews'),
              _buildStatItem(context, '24/7', 'Support'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String number, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            number,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white
                      .withValues(red: 255, green: 255, blue: 255, alpha: 230),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
