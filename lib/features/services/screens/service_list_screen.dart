import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import '../widgets/service_card.dart';
import '../../booking/screens/booking_screen.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Select a Service')),
      body: FutureBuilder(
        future: serviceProvider.fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading services'));
          }
          if (serviceProvider.services.isEmpty) {
            return Center(child: Text('No Services Found'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3 / 2,
            ),
            itemCount: serviceProvider.services.length,
            itemBuilder: (context, index) {
              // Use ServiceModel here
              final service = serviceProvider.services[index];

              return ServiceCard(
                service: service,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(service: service),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
