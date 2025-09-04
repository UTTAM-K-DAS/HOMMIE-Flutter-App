import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../models/provider_model.dart';
import '../services/provider_service.dart';

class ProviderManagementScreen extends StatefulWidget {
  const ProviderManagementScreen({super.key});

  @override
  State<ProviderManagementScreen> createState() =>
      _ProviderManagementScreenState();
}

class _ProviderManagementScreenState extends State<ProviderManagementScreen> {
  final ProviderService _providerService = ProviderService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    developer.log(
      'ProviderManagementScreen initialized',
      name: 'provider_management',
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Management'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search providers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Provider List
          Expanded(
            child: StreamBuilder<List<ProviderModel>>(
              stream: _searchQuery.isEmpty
                  ? _providerService.getProviders()
                  : _providerService.searchProviders(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  developer.log(
                    'Error loading providers: ${snapshot.error}',
                    name: 'provider_management',
                  );
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading providers: ${snapshot.error}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final providers = snapshot.data ?? [];

                if (providers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No providers found'
                              : 'No providers found for "$_searchQuery"',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          provider.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(provider.email ?? 'No email'),
                            if (provider.phone?.isNotEmpty == true)
                              Text('Phone: ${provider.phone}'),
                            if (provider.category?.isNotEmpty == true)
                              Text('Category: ${provider.category}'),
                            if (provider.pricePerHour != null &&
                                provider.pricePerHour! > 0)
                              Text('Price: \$${provider.pricePerHour}/hour'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (provider.isActive == true)
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    (provider.isActive == true)
                                        ? 'Active'
                                        : 'Inactive',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (provider.isActive == true)
                                        ? Colors.blue
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    (provider.isActive == true)
                                        ? 'Available'
                                        : 'Unavailable',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: provider.isActive == true,
                              onChanged: (value) =>
                                  _toggleProviderStatus(provider, value),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (action) =>
                                  _handleProviderAction(action, provider),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        (provider.isActive == true)
                                            ? Icons.check_circle
                                            : Icons.error,
                                        color: (provider.isActive == true)
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        (provider.isActive == true)
                                            ? 'Active'
                                            : 'Inactive',
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProviderDialog,
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _toggleProviderStatus(
    ProviderModel provider,
    bool isActive,
  ) async {
    try {
      developer.log(
        'Toggling provider status: ${provider.name} to $isActive',
        name: 'provider_management',
      );

      final updatedProvider = ProviderModel(
        id: provider.id,
        name: provider.name,
        email: provider.email,
        phone: provider.phone,
        address: provider.address,
        description: provider.description,
        category: provider.category,
        pricePerHour: provider.pricePerHour,
        services: provider.services,
        isActive: isActive,
        isAvailable: isActive,
        createdAt: provider.createdAt,
        updatedAt: DateTime.now(),
      );

      await _providerService.updateProvider(provider.id, updatedProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Provider ${isActive ? 'activated' : 'deactivated'} successfully',
            ),
            backgroundColor: isActive ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      developer.log(
        'Error toggling provider status: $e',
        name: 'provider_management',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating provider: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleProviderAction(String action, ProviderModel provider) {
    switch (action) {
      case 'edit':
        _showEditProviderDialog(provider);
        break;
      case 'delete':
        _showDeleteConfirmation(provider);
        break;
    }
  }

  void _showAddProviderDialog() {
    showDialog(context: context, builder: (context) => _ProviderDialog());
  }

  void _showEditProviderDialog(ProviderModel provider) {
    showDialog(
      context: context,
      builder: (context) => _ProviderDialog(provider: provider),
    );
  }

  void _showDeleteConfirmation(ProviderModel provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Provider'),
        content: Text('Are you sure you want to delete ${provider.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteProvider(provider);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProvider(ProviderModel provider) async {
    try {
      developer.log(
        'Deleting provider: ${provider.name}',
        name: 'provider_management',
      );
      await _providerService.deleteProvider(provider.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Provider deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      developer.log('Error deleting provider: $e', name: 'provider_management');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting provider: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _ProviderDialog extends StatefulWidget {
  final ProviderModel? provider;

  const _ProviderDialog({this.provider});

  @override
  State<_ProviderDialog> createState() => _ProviderDialogState();
}

class _ProviderDialogState extends State<_ProviderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedCategory = 'home-cleaning';
  bool _isActive = true;
  bool _isLoading = false;

  final List<String> _categories = [
    'home-cleaning',
    'plumbing',
    'electrical',
    'gardening',
    'repair',
    'maintenance',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.provider != null) {
      _nameController.text = widget.provider!.name;
      _emailController.text = widget.provider!.email ?? '';
      _phoneController.text = widget.provider!.phone ?? '';
      _addressController.text = widget.provider!.address ?? '';
      _descriptionController.text = widget.provider!.description ?? '';
      _priceController.text = widget.provider!.pricePerHour?.toString() ?? '';
      _selectedCategory = widget.provider!.category ?? 'home-cleaning';
      _isActive = widget.provider!.isActive ?? true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.provider == null ? 'Add Provider' : 'Edit Provider'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category
                            .split('-')
                            .map(
                              (word) =>
                                  word[0].toUpperCase() + word.substring(1),
                            )
                            .join(' '),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price per Hour (\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final price = double.tryParse(value);
                      if (price == null || price < 0) {
                        return 'Enter a valid price';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value ?? true;
                        });
                      },
                    ),
                    const Text('Active'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveProvider,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.provider == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  Future<void> _saveProvider() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = ProviderModel(
        id: widget.provider?.id ?? '',
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        pricePerHour: _priceController.text.isNotEmpty
            ? double.tryParse(_priceController.text)
            : null,
        services: [],
        isActive: _isActive,
        isAvailable: _isActive,
        createdAt: widget.provider?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final providerService = ProviderService();

      if (widget.provider == null) {
        // Add new provider
        await providerService.addProvider(provider);
        developer.log(
          'Provider added successfully: ${provider.name}',
          name: 'provider_management',
        );
      } else {
        // Update existing provider
        await providerService.updateProvider(widget.provider!.id, provider);
        developer.log(
          'Provider updated successfully: ${provider.name}',
          name: 'provider_management',
        );
      }

      Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Provider ${widget.provider == null ? 'added' : 'updated'} successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      developer.log('Error saving provider: $e', name: 'provider_management');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving provider: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
