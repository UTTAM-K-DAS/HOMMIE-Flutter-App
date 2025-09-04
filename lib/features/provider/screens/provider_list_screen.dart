import 'package:flutter/material.dart';
import '../../../data/models/service_provider_model.dart';
import '../../../data/provider_data_provider.dart';

class ProviderListScreen extends StatefulWidget {
  final String? category;

  const ProviderListScreen({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  _ProviderListScreenState createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  double _minRating = 0.0;
  bool _onlyAvailable = false;
  List<ServiceProvider> _providers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);

    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network call

    List<ServiceProvider> providers;
    if (widget.category != null) {
      providers = ProviderDataProvider.getProvidersByCategory(widget.category!);
    } else {
      providers = ProviderDataProvider.getAllProviders();
    }

    // Apply filters
    providers = providers.where((provider) {
      if (_minRating > 0 && provider.rating < _minRating) return false;
      if (_onlyAvailable && !provider.isAvailable) return false;
      return true;
    }).toList();

    setState(() {
      _providers = providers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category ?? 'Service Providers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _providers.isEmpty
              ? const Center(child: Text('No providers found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _providers.length,
                  itemBuilder: (context, index) {
                    final provider = _providers[index];
                    return _buildProviderCard(provider);
                  },
                ),
    );
  }

  Widget _buildProviderCard(ServiceProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/provider-details',
            arguments: {'providerId': provider.id},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Provider Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    child: Text(
                      provider.name.split(' ').map((n) => n[0]).take(2).join(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          provider.location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${provider.formattedRating} (${provider.totalReviews} reviews)',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: provider.isAvailable
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      provider.isAvailable ? 'Available' : 'Busy',
                      style: TextStyle(
                        color: provider.isAvailable
                            ? Colors.green[800]
                            : Colors.red[800],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Bio
              Text(
                provider.bio,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Skills/Categories
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: provider.skills.take(3).map((skill) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // Stats and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.work,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${provider.totalJobs} jobs',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        provider.experienceYears,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    provider.formattedHourlyRate,
                    style: TextStyle(
                      fontSize: 16,
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

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Providers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Minimum Rating Slider
            const Text('Minimum Rating'),
            Slider(
              value: _minRating,
              min: 0,
              max: 5,
              divisions: 10,
              label: _minRating.toString(),
              onChanged: (value) {
                setState(() => _minRating = value);
              },
            ),

            // Only Available Switch
            SwitchListTile(
              title: const Text('Only Available'),
              value: _onlyAvailable,
              onChanged: (value) {
                setState(() => _onlyAvailable = value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadProviders();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
