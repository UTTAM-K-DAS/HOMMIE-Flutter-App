import 'package:flutter/material.dart';
import '../../../models/unified_service_model.dart';
import '../../services/enums/service_type.dart';
import '../../services/widgets/service_card.dart';

class ServicesScreen extends StatelessWidget {
  final String title;
  final ServiceType? serviceType;
  final bool isRecommended;

  const ServicesScreen({
    Key? key,
    required this.title,
    this.serviceType,
    this.isRecommended = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _getServices().length,
        itemBuilder: (context, index) {
          return ServiceCard(
            service: _getServices()[index],
            onTap: () {
              // Handle tap - navigate to service detail or booking
              Navigator.pushNamed(
                context,
                '/service-details',
                arguments: {'service': _getServices()[index]},
              );
            },
          );
        },
      ),
    );
  }

  List<ServiceModel> _getServices() {
    // This is sample data - in a real app, you would fetch this from your backend
    if (serviceType == ServiceType.plumbing) {
      return [
        ServiceModel(
          id: 'tap_repair',
          name: 'Tap Repair',
          icon: '🔧',
          description: 'Fix leaking taps and faucets',
          imageUrl: 'https://picsum.photos/300/200?random=101',
          price: 199,
          category: 'Plumbing',
          duration: 60,
          packages: [],
        ),
        ServiceModel(
          id: 'pipe_repair',
          name: 'Pipe Repair',
          icon: '🔧',
          description: 'Fix leaking or damaged pipes',
          imageUrl: 'https://picsum.photos/300/200?random=102',
          price: 299,
          category: 'Plumbing',
          duration: 120,
          packages: [],
        ),
      ];
    } else if (serviceType == ServiceType.electrical) {
      return [
        ServiceModel(
          id: 'switch_repair',
          name: 'Switch Repair',
          icon: '⚡',
          description: 'Fix electrical switches and sockets',
          imageUrl: 'https://picsum.photos/300/200?random=103',
          price: 149,
          category: 'Electrical',
          duration: 30,
          packages: [],
        ),
        ServiceModel(
          id: 'fan_installation',
          name: 'Fan Installation',
          icon: '⚡',
          description: 'Install new ceiling fans',
          imageUrl: 'https://picsum.photos/300/200?random=104',
          price: 399,
          category: 'Electrical',
          duration: 120,
          packages: [],
        ),
      ];
    } else if (isRecommended) {
      return [
        ServiceModel(
          id: 'ac_service',
          name: 'AC Service',
          icon: '❄️',
          description: 'Professional AC servicing and repair',
          imageUrl: 'https://picsum.photos/300/200?random=105',
          price: 299,
          category: 'Appliances',
          duration: 120,
          packages: [],
        ),
        ServiceModel(
          id: 'cleaning',
          name: 'Cleaning',
          icon: '🧹',
          description: 'Professional home cleaning services',
          imageUrl: 'https://picsum.photos/300/200?random=106',
          price: 199,
          category: 'Cleaning',
          duration: 180,
          packages: [],
        ),
        ServiceModel(
          id: 'beauty',
          name: 'Beauty',
          icon: '💅',
          description: 'Professional beauty services at home',
          imageUrl: 'https://picsum.photos/300/200?random=107',
          price: 149,
          category: 'Beauty',
          duration: 60,
          packages: [],
        ),
      ];
    }

    // Default services for all categories
    return [
      ServiceModel(
        id: 'general_service_1',
        name: 'General Service 1',
        icon: '🛠️',
        description: 'General home service',
        imageUrl: 'https://picsum.photos/300/200?random=108',
        price: 199,
        category: 'General',
        duration: 60,
        packages: [],
      ),
      ServiceModel(
        id: 'general_service_2',
        name: 'General Service 2',
        icon: '🛠️',
        description: 'General home service',
        imageUrl: 'https://picsum.photos/300/200?random=109',
        price: 299,
        category: 'General',
        duration: 90,
        packages: [],
      ),
    ];
  }
}
