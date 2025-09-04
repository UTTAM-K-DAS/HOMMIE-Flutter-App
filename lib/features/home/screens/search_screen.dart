import 'package:flutter/material.dart';
import '../../../data/service_data_provider.dart';
import '../../services/widgets/service_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Popular';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search services...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
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
          _buildFilterChips(),
          Expanded(
            child: _searchQuery.isEmpty
                ? _buildSuggestedServices()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final categories = ['Popular'] + ServiceDataProvider.getCategories();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) => _buildChip(category)).toList(),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedFilter = label;
            });
          }
        },
      ),
    );
  }

  Widget _buildSuggestedServices() {
    final services = ServiceDataProvider.getAllServices().take(8).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Popular Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return ServiceCard(
                service: services[index],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/service',
                    arguments: {'service': services[index]},
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // Filter services based on search query and category
    final allServices = ServiceDataProvider.getAllServices();
    final results = allServices.where((service) {
      final nameMatches =
          service.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final descriptionMatches = service.description
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final categoryMatches =
          _selectedFilter == 'Popular' || service.category == _selectedFilter;
      return (nameMatches || descriptionMatches) && categoryMatches;
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('No services found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ServiceCard(
          service: results[index],
          onTap: () {
            Navigator.pushNamed(
              context,
              '/service',
              arguments: {'service': results[index]},
            );
          },
        ),
      ),
    );
  }
}
