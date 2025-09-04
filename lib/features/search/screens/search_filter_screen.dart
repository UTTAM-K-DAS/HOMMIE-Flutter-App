import 'package:flutter/material.dart';
import '../providers/search_provider.dart';
import 'package:provider/provider.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({Key? key}) : super(key: key);

  @override
  _SearchFilterScreenState createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  RangeValues _priceRange = RangeValues(0, 1000);
  String _selectedCategory = 'All';
  double _minRating = 0;
  bool _onlyAvailable = true;

  final List<String> _categories = [
    'All',
    'Cleaning',
    'Maintenance',
    'Home Improvement',
    'Personal',
    'Outdoor',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentFilters();
  }

  void _loadCurrentFilters() {
    final searchProvider = context.read<SearchProvider>();
    setState(() {
      _priceRange = RangeValues(
        searchProvider.minPrice,
        searchProvider.maxPrice,
      );
      _selectedCategory = searchProvider.category ?? 'All';
      _minRating = searchProvider.minRating;
      _onlyAvailable = searchProvider.onlyAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Services'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceRangeFilter(),
            const SizedBox(height: 30),
            _buildCategoryFilter(),
            const SizedBox(height: 30),
            _buildRatingFilter(),
            const SizedBox(height: 30),
            _buildAvailabilityFilter(),
          ],
        ),
      ),
      bottomNavigationBar: _buildApplyButton(),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            'TK ${_priceRange.start.round()}',
            'TK ${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() => _priceRange = values);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TK 0'),
            Text('TK 1000'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _categories.map((category) {
            return ChoiceChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() => _selectedCategory = selected ? category : 'All');
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _minRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() => _minRating = index + 1.0);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAvailabilityFilter() {
    return SwitchListTile(
      title: Text(
        'Show Only Available',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      value: _onlyAvailable,
      onChanged: (value) {
        setState(() => _onlyAvailable = value);
      },
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _applyFilters,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'Apply Filters',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _priceRange = RangeValues(0, 1000);
      _selectedCategory = 'All';
      _minRating = 0;
      _onlyAvailable = true;
    });
  }

  void _applyFilters() {
    final searchProvider = context.read<SearchProvider>();
    searchProvider.updateFilters(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      category: _selectedCategory == 'All' ? null : _selectedCategory,
      minRating: _minRating,
      onlyAvailable: _onlyAvailable,
    );
    Navigator.pop(context);
  }
}
