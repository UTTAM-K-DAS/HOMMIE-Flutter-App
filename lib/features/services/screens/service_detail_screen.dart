import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('AC Servicing'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: const Center(
                  child: Text('❄️', style: TextStyle(fontSize: 64)),
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
                  ServicePackageCard(
                    title: 'Basic Service',
                    description: 'Basic AC cleaning and maintenance',
                    price: 'TK 299',
                    onTap: () => Navigator.pushNamed(context, '/booking'),
                  ),
                  ServicePackageCard(
                    title: 'Standard Service',
                    description: 'Deep cleaning with gas check',
                    price: 'TK 499',
                    onTap: () => Navigator.pushNamed(context, '/booking'),
                  ),
                  ServicePackageCard(
                    title: 'Premium Service',
                    description: 'Complete service with parts check',
                    price: 'TK 799',
                    onTap: () => Navigator.pushNamed(context, '/booking'),
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

class ServicePackageCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final VoidCallback onTap;

  const ServicePackageCard({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Text(price),
        onTap: onTap,
      ),
    );
  }
}
