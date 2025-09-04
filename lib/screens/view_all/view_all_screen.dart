import 'package:flutter/material.dart';
import '../../features/services/screens/service_details_screen.dart';
import '../../models/unified_service_model.dart';

class ViewAllScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> services;

  const ViewAllScreen({
    Key? key,
    required this.title,
    required this.services,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildServiceCard(context, service);
          },
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        // Convert to ServiceModel
        final serviceModel = ServiceModel(
          id: service['id'] ??
              'unknown_${DateTime.now().millisecondsSinceEpoch}',
          name: service['name'] ?? 'Unknown Service',
          icon: service['icon'] ?? '🔧',
          description:
              'Professional ${service['name']} services at your doorstep. Our expert service providers ensure quality work and customer satisfaction.',
          imageUrl: service['imageUrl'] ??
              'https://via.placeholder.com/300x200/E0E0E0/757575?text=Service',
          price: _extractPrice(service['price']),
          category: title, // Use the screen title as category
          duration: service['duration'] ?? 60,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(
              service: serviceModel,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: (service['color'] as Color?)?.withValues(alpha: 0.1) ??
                    Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  service['icon'] ?? '🔧',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                service['name'] ?? 'Service',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'From ${service['price'] ?? '৳299'}',
              style: TextStyle(
                color: (service['color'] as Color?) ?? Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: (service['color'] as Color?)?.withValues(alpha: 0.1) ??
                    Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '4.8 ⭐ (127)',
                style: TextStyle(
                  color: (service['color'] as Color?) ?? Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _extractPrice(dynamic price) {
    if (price == null) return 299.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      final number = RegExp(r'[0-9]+').firstMatch(price);
      return number != null ? double.parse(number.group(0)!) : 299.0;
    }
    return 299.0;
  }
}
