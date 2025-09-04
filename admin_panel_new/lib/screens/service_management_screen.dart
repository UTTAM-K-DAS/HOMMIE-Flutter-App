import 'package:flutter/material.dart';
import '../models/unified_service_model.dart';
import '../models/service_category_model.dart';
import '../services/service_management_service.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() =>
      _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen>
    with SingleTickerProviderStateMixin {
  final ServiceManagementService _serviceService = ServiceManagementService();
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Management'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Services'),
            Tab(text: 'Categories'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_tabController.index == 0) {
                _showAddServiceDialog();
              } else {
                _showAddCategoryDialog();
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildServicesTab(), _buildCategoriesTab()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddServiceDialog();
          } else {
            _showAddCategoryDialog();
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(_tabController.index == 0 ? 'Add Service' : 'Add Category'),
      ),
    );
  }

  Widget _buildServicesTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search Services',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        // Services List
        Expanded(
          child: StreamBuilder<List<ServiceModel>>(
            stream: _searchQuery.isEmpty
                ? _serviceService.getServices()
                : _serviceService.searchServices(_searchQuery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final services = snapshot.data ?? [];

              if (services.isEmpty) {
                return const Center(child: Text('No services found'));
              }

              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: service.imageUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(service.imageUrl),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              child: Text(
                                service.name.isNotEmpty ? service.name[0] : 'S',
                              ),
                            ),
                      title: Text(service.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: \$${service.price.toStringAsFixed(2)}'),
                          Text('Category: ${service.categoryId}'),
                          Row(
                            children: [
                              Icon(
                                service.isAvailable
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: service.isAvailable
                                    ? Colors.green
                                    : Colors.red,
                                size: 16,
                              ),
                              Text(
                                service.isAvailable
                                    ? ' Available'
                                    : ' Unavailable',
                                style: TextStyle(
                                  color: service.isAvailable
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
                            _handleServiceAction(value, service),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'toggle',
                            child: ListTile(
                              leading: Icon(
                                service.isAvailable
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              title: Text(
                                service.isAvailable
                                    ? 'Make Unavailable'
                                    : 'Make Available',
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text('Delete'),
                            ),
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
    );
  }

  Widget _buildCategoriesTab() {
    return StreamBuilder<List<ServiceCategoryModel>>(
      stream: _serviceService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final categories = snapshot.data ?? [];

        if (categories.isEmpty) {
          return const Center(child: Text('No categories found'));
        }

        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: category.iconUrl.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(category.iconUrl),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Text(
                          category.name.isNotEmpty ? category.name[0] : 'C',
                        ),
                      ),
                title: Text(category.name),
                subtitle: Text(category.description),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) => _handleCategoryAction(value, category),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'services',
                      child: ListTile(
                        leading: Icon(Icons.list),
                        title: Text('View Services'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleServiceAction(String action, ServiceModel service) async {
    switch (action) {
      case 'edit':
        _showEditServiceDialog(service);
        break;
      case 'toggle':
        await _serviceService.toggleServiceAvailability(
          service.id,
          !service.isAvailable,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Service ${service.isAvailable ? 'disabled' : 'enabled'} successfully',
              ),
            ),
          );
        }
        break;
      case 'delete':
        _showDeleteServiceConfirmation(service);
        break;
    }
  }

  void _handleCategoryAction(
    String action,
    ServiceCategoryModel category,
  ) async {
    switch (action) {
      case 'edit':
        _showEditCategoryDialog(category);
        break;
      case 'services':
        _showCategoryServices(category);
        break;
      case 'delete':
        _showDeleteCategoryConfirmation(category);
        break;
    }
  }

  void _showAddServiceDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController();
    final imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Service Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category ID'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                ),
              ),
            ],
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
                  priceController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty) {
                final service = ServiceModel(
                  id: '',
                  name: nameController.text,
                  icon: '🛠️',
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : 'No description',
                  price: double.tryParse(priceController.text) ?? 0.0,
                  category: categoryController.text,
                  categoryId: categoryController.text,
                  duration: 60,
                  imageUrl: imageUrlController.text.isNotEmpty
                      ? imageUrlController.text
                      : '',
                  isAvailable: true,
                );

                await _serviceService.addService(service);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Service added successfully')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final iconUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: iconUrlController,
                decoration: const InputDecoration(
                  labelText: 'Icon URL (optional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final category = ServiceCategoryModel(
                  id: '',
                  name: nameController.text,
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : 'No description',
                  iconName: 'category',
                  iconUrl: iconUrlController.text.isNotEmpty
                      ? iconUrlController.text
                      : '',
                  imageUrl: '',
                  isActive: true,
                  createdAt: DateTime.now(),
                  subTypes: [],
                );

                await _serviceService.addCategory(category);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category added successfully'),
                    ),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditServiceDialog(ServiceModel service) {
    final nameController = TextEditingController(text: service.name);
    final descriptionController = TextEditingController(
      text: service.description,
    );
    final priceController = TextEditingController(
      text: service.price.toString(),
    );
    final categoryController = TextEditingController(text: service.categoryId);
    final imageUrlController = TextEditingController(text: service.imageUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Service Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category ID'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedService = ServiceModel(
                id: service.id,
                name: nameController.text,
                icon: service.icon,
                description: descriptionController.text.isNotEmpty
                    ? descriptionController.text
                    : 'No description',
                price: double.tryParse(priceController.text) ?? service.price,
                category: service.category,
                categoryId: categoryController.text,
                duration: service.duration,
                imageUrl: imageUrlController.text.isNotEmpty
                    ? imageUrlController.text
                    : '',
                isAvailable: service.isAvailable,
              );

              await _serviceService.updateService(service.id, updatedService);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Service updated successfully')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(ServiceCategoryModel category) {
    final nameController = TextEditingController(text: category.name);
    final descriptionController = TextEditingController(
      text: category.description,
    );
    final iconUrlController = TextEditingController(text: category.iconUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextField(
                controller: iconUrlController,
                decoration: const InputDecoration(labelText: 'Icon URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedCategory = ServiceCategoryModel(
                id: category.id,
                name: nameController.text,
                description: descriptionController.text.isNotEmpty
                    ? descriptionController.text
                    : 'No description',
                iconName: category.iconName,
                iconUrl: iconUrlController.text.isNotEmpty
                    ? iconUrlController.text
                    : '',
                imageUrl: category.imageUrl,
                isActive: category.isActive,
                createdAt: category.createdAt,
                subTypes: category.subTypes,
              );

              await _serviceService.updateCategory(
                category.id,
                updatedCategory,
              );
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category updated successfully'),
                  ),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteServiceConfirmation(ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete ${service.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _serviceService.deleteService(service.id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Service deleted successfully')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryConfirmation(ServiceCategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete ${category.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _serviceService.deleteCategory(category.id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category deleted successfully'),
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCategoryServices(ServiceCategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${category.name} Services'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: StreamBuilder<List<ServiceModel>>(
            stream: _serviceService.getServicesByCategory(category.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final services = snapshot.data ?? [];
              if (services.isEmpty) {
                return const Center(
                  child: Text('No services in this category'),
                );
              }

              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ListTile(
                    title: Text(service.name),
                    subtitle: Text('\$${service.price.toStringAsFixed(2)}'),
                    trailing: Icon(
                      service.isAvailable ? Icons.check_circle : Icons.cancel,
                      color: service.isAvailable ? Colors.green : Colors.red,
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
