import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/unified_service_model.dart';
import '../features/provider/models/provider_model.dart';
import '../services/provider_service.dart';

class ProviderSelectionScreen extends StatelessWidget {
  final ServiceModel selectedService;

  const ProviderSelectionScreen({Key? key, required this.selectedService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ...existing code for header and provider list...
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: FadeInUp(
                child: Padding(
                  padding: EdgeInsets.only(top: 120.0, right: 20.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose a Provider',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'for ${selectedService.name}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: StreamBuilder<List<ProviderModel>>(
          stream:
              ProviderService.getProvidersByCategory(selectedService.category)
                  as Stream<List<ProviderModel>>?,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No providers available for this service.'),
              );
            }
            final providers = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final provider = providers[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 200 * index),
                    child: ProviderCard(provider: provider),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProviderCard extends StatelessWidget {
  final ProviderModel provider;

  const ProviderCard({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Provider Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: provider.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(provider.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: provider.imageUrl.isEmpty
                    ? Colors.blue.withAlpha(25)
                    : null,
              ),
              child: provider.imageUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.blue, size: 30)
                  : null,
            ),
            const SizedBox(width: 16),
            // Provider Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${provider.experience} years experience',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        provider.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '\$${provider.pricePerHour.toStringAsFixed(0)}/hr',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
