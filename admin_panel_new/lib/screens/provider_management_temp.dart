import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import '../services/provider_service.dart';
import 'dart:developer' as developer;

class ProviderManagementScreen extends StatefulWidget {
  const ProviderManagementScreen({super.key});

  @override
  State<ProviderManagementScreen> createState() =>
      _ProviderManagementScreenState();
}

class _ProviderManagementScreenState extends State<ProviderManagementScreen> {
  final ProviderService _providerService = ProviderService();
  List<ProviderModel> providers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Management'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProviderDialog(),
        tooltip: 'Add Provider',
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : providers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No providers found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAddProviderDialog(),
                    child: const Text('Add First Provider'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total Providers: ${providers.length}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _loadProviders,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: providers.length,
                    itemBuilder: (context, index) {
                      final provider = providers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              provider.name.isNotEmpty
                                  ? provider.name[0].toUpperCase()
                                  : 'P',
                            ),
                          ),
                          title: Text(provider.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.email ?? ''),
                              if (provider.phone?.isNotEmpty == true)
                                Text('Phone: ${provider.phone}'),
                              if (provider.category?.isNotEmpty == true)
                                Text('Category: ${provider.category}'),
                              if ((provider.pricePerHour ?? 0) > 0)
                                Text('Price: \$${provider.pricePerHour}/hr'),
                              Row(
                                children: [
                                  Icon(
                                    (provider.isActive ?? false)
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: (provider.isActive ?? false)
                                        ? Colors.green
                                        : Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (provider.isActive ?? false)
                                        ? 'Active'
                                        : 'Inactive',
                                    style: TextStyle(
                                      color: (provider.isActive ?? false)
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) =>
                                _handleProviderAction(value, provider),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                ),
                              ),
                              PopupMenuItem(
                                value: (provider.isActive ?? false)
                                    ? 'deactivate'
                                    : 'activate',
                                child: ListTile(
                                  leading: Icon(
                                    (provider.isActive ?? false)
                                        ? Icons.block
                                        : Icons.check_circle,
                                  ),
                                  title: Text(
                                    (provider.isActive ?? false)
                                        ? 'Deactivate'
                                        : 'Activate',
                                  ),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _loadProviders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final providersList = await _providerService.getProviders().first;
      setState(() {
        providers = providersList;
        isLoading = false;
      });
    } catch (e) {
      developer.log('Error loading providers: $e', name: 'ProviderManagement');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading providers: $e')));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleProviderAction(String action, ProviderModel provider) {
    switch (action) {
      case 'edit':
        _showEditProviderDialog(provider);
        break;
      case 'activate':
      case 'deactivate':
        _toggleProviderStatus(provider);
        break;
      case 'delete':
        _showDeleteConfirmation(provider);
        break;
    }
  }

  Future<void> _toggleProviderStatus(ProviderModel provider) async {
    try {
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
        isActive: !(provider.isActive ?? false),
        isAvailable: provider.isAvailable,
        createdAt: provider.createdAt,
        rating: provider.rating,
      );

      await _providerService.updateProvider(provider.id, updatedProvider);
      _loadProviders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Provider ${(updatedProvider.isActive ?? false) ? 'activated' : 'deactivated'} successfully',
            ),
          ),
        );
      }
    } catch (e) {
      developer.log(
        'Error toggling provider status: $e',
        name: 'ProviderManagement',
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating provider: $e')));
      }
    }
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProvider(provider);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProvider(ProviderModel provider) async {
    try {
      await _providerService.deleteProvider(provider.id);
      _loadProviders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Provider deleted successfully')),
        );
      }
    } catch (e) {
      developer.log('Error deleting provider: $e', name: 'ProviderManagement');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting provider: $e')));
      }
    }
  }

  void _showAddProviderDialog() {
    _showProviderDialog();
  }

  void _showEditProviderDialog(ProviderModel provider) {
    _showProviderDialog(existingProvider: provider);
  }

  void _showProviderDialog({ProviderModel? existingProvider}) {
    final isEditing = existingProvider != null;
    final nameController = TextEditingController(
      text: existingProvider?.name ?? '',
    );
    final emailController = TextEditingController(
      text: existingProvider?.email ?? '',
    );
    final phoneController = TextEditingController(
      text: existingProvider?.phone ?? '',
    );
    final addressController = TextEditingController(
      text: existingProvider?.address ?? '',
    );
    final descriptionController = TextEditingController(
      text: existingProvider?.description ?? '',
    );
    final priceController = TextEditingController(
      text: existingProvider?.pricePerHour?.toString() ?? '',
    );

    String selectedCategory = existingProvider?.category ?? '';

    final categories = [
      'Home Cleaning',
      'Plumbing',
      'Electrical',
      'Carpentry',
      'Painting',
      'Gardening',
      'Repair & Maintenance',
      'Beauty & Wellness',
      'Tutoring',
      'Pet Care',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Provider' : 'Add Provider'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory.isEmpty ? null : selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price per Hour (\$)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                try {
                  final provider = ProviderModel(
                    id: existingProvider?.id ?? '',
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    address: addressController.text,
                    description: descriptionController.text,
                    category: selectedCategory,
                    pricePerHour: double.tryParse(priceController.text),
                    services: existingProvider?.services ?? [],
                    isActive: existingProvider?.isActive ?? true,
                    isAvailable: existingProvider?.isAvailable ?? true,
                    createdAt: existingProvider?.createdAt ?? DateTime.now(),
                    rating: existingProvider?.rating ?? 0.0,
                  );

                  if (isEditing) {
                    await _providerService.updateProvider(
                      provider.id,
                      provider,
                    );
                  } else {
                    await _providerService.addProvider(provider);
                  }

                  Navigator.pop(context);
                  _loadProviders();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Provider ${isEditing ? 'updated' : 'added'} successfully',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  developer.log(
                    'Error saving provider: $e',
                    name: 'ProviderManagement',
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving provider: $e')),
                    );
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all required fields'),
                  ),
                );
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
