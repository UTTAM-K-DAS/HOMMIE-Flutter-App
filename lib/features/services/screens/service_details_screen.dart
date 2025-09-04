import 'package:flutter/material.dart';
import '../../../models/unified_service_model.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  int selectedPackageIndex = 0;

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.service.name),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withAlpha(204),
                      Theme.of(context).primaryColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: widget.service.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.service.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  widget.service.icon,
                                  style: const TextStyle(fontSize: 50),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.service.icon,
                              style: const TextStyle(fontSize: 50),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.service.formattedRating} (${widget.service.totalReviews} reviews)',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'About this service',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.service.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Service Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                      'Duration', '${widget.service.duration} minutes'),
                  _buildDetailRow('Category', widget.service.category),
                  _buildDetailRow('Base Price', widget.service.formattedPrice),

                  // Packages section
                  if (widget.service.packages.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Available Packages',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ...widget.service.packages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final package = entry.value;
                      final isSelected = selectedPackageIndex == index;

                      return Card(
                        color: isSelected
                            ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                            : null,
                        child: ListTile(
                          leading: Radio<int>(
                            value: index,
                            groupValue: selectedPackageIndex,
                            onChanged: (value) {
                              setState(() {
                                selectedPackageIndex = value!;
                              });
                            },
                          ),
                          title: Text(
                            package.name,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(package.description),
                          trailing: Text(
                            package.formattedPrice,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.service.isAvailable
                          ? () {
                              final selectedPackage =
                                  widget.service.packages.isNotEmpty
                                      ? widget.service
                                          .packages[selectedPackageIndex]
                                      : null;
                              Navigator.pushNamed(
                                context,
                                '/booking',
                                arguments: {
                                  'service': widget.service,
                                  'selectedPackage': selectedPackage,
                                },
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        widget.service.isAvailable
                            ? 'Book Now'
                            : 'Not Available',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
