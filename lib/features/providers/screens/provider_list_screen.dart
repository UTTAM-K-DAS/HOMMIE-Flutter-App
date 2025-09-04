import 'package:flutter/material.dart';
import '../../../models/unified_service_model.dart';
import '../../../services/provider_service.dart';
import '../../services/enums/service_type.dart';
import '../../provider/models/provider_model.dart';
import 'provider_detail_screen.dart';

class ProviderListScreen extends StatefulWidget {
  final ServiceType serviceType;
  final String serviceName;

  const ProviderListScreen({
    Key? key,
    required this.serviceType,
    required this.serviceName,
  }) : super(key: key);

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  String _selectedFilter = 'Rating';

  void _sortProviders(List<ProviderModel> providers) {
    switch (_selectedFilter) {
      case 'Rating':
        providers.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Price':
        providers.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
        break;
      case 'Experience':
        providers.sort((a, b) => b.experience.compareTo(a.experience));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get category name from service type
    String categoryName = widget.serviceType.toString().split('.').last;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.serviceName} Providers'),
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
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: StreamBuilder<List<ProviderModel>>(
              stream: ProviderService.getProvidersByCategory(categoryName)
                  as Stream<List<ProviderModel>>?,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Error loading providers'),
                        SizedBox(height: 8),
                        Text(snapshot.error.toString(),
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off_outlined,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No providers available'),
                        SizedBox(height: 8),
                        Text('Please check back later',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                final providers = snapshot.data!;
                _sortProviders(providers);

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    return _buildProviderCard(context, provider);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort & Filter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Rating', false),
                _buildFilterChip('Price', false),
                _buildFilterChip('Experience', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool defaultSelected) {
    final isSelected = _selectedFilter == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              _selectedFilter = label;
            });
          }
        },
      ),
    );
  }

  Widget _buildProviderCard(BuildContext context, ProviderModel provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProviderDetailScreen(
                providerId: provider.id,
                service: ServiceModel(
                  id: provider.id,
                  name: widget.serviceName,
                  icon: provider.name.substring(0, 2).toUpperCase(),
                  description: provider.description,
                  imageUrl: provider.imageUrl.isNotEmpty
                      ? provider.imageUrl
                      : 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=${Uri.encodeComponent(widget.serviceName)}',
                  price: provider.pricePerHour,
                  category: provider.category,
                  duration: 60,
                  packages: [
                    ServicePackage(
                      name: 'Basic',
                      description: 'Basic ${widget.serviceName} service',
                      price: provider.pricePerHour,
                    ),
                    ServicePackage(
                      name: 'Standard',
                      description:
                          'Standard ${widget.serviceName} service with additional features',
                      price: provider.pricePerHour * 1.5,
                    ),
                    ServicePackage(
                      name: 'Premium',
                      description:
                          'Premium ${widget.serviceName} service with all features',
                      price: provider.pricePerHour * 2,
                    ),
                  ],
                ),
                providerName: provider.name,
                rating: provider.rating,
                reviews: provider.reviews.length,
                experience: '${provider.experience}+ years',
                avatar: provider.name.substring(0, 2).toUpperCase(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      provider.name
                          .split(' ')
                          .map((n) => n.isNotEmpty ? n[0] : '')
                          .take(2)
                          .join()
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${provider.rating.toStringAsFixed(1)} (${provider.reviews.length} reviews)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        if (!provider.isAvailable)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Currently Unavailable',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${provider.experience}+ years',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        provider.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '৳${provider.pricePerHour.toStringAsFixed(0)}/hr',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
