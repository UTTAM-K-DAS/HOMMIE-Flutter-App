import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class DetailedProviderManagementScreen extends StatefulWidget {
  const DetailedProviderManagementScreen({super.key});

  @override
  State<DetailedProviderManagementScreen> createState() =>
      _DetailedProviderManagementScreenState();
}

class _DetailedProviderManagementScreenState
    extends State<DetailedProviderManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Management'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddProviderDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Providers',
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
          // Providers List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _searchQuery.isEmpty
                  ? _firestore
                        .collection('users')
                        .where('role', isEqualTo: 'provider')
                        .snapshots()
                  : _firestore
                        .collection('users')
                        .where('role', isEqualTo: 'provider')
                        .where('name', isGreaterThanOrEqualTo: _searchQuery)
                        .where(
                          'name',
                          isLessThanOrEqualTo: '$_searchQuery\uf8ff',
                        )
                        .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final providers = snapshot.data?.docs ?? [];

                if (providers.isEmpty) {
                  return const Center(child: Text('No providers found'));
                }

                return ListView.builder(
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    final data = provider.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              data['profile']?['avatar'] != null &&
                                  data['profile']['avatar'].isNotEmpty
                              ? NetworkImage(data['profile']['avatar'])
                              : null,
                          backgroundColor: Colors.orange,
                          child:
                              data['profile']?['avatar'] == null ||
                                  data['profile']['avatar'].isEmpty
                              ? Text(
                                  data['name']?.toString().isNotEmpty == true
                                      ? data['name'][0].toUpperCase()
                                      : 'P',
                                  style: const TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                        title: Text(data['name'] ?? 'Unknown Provider'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${data['email'] ?? 'No email'}'),
                            Text('Phone: ${data['phone'] ?? 'No phone'}'),
                            Row(
                              children: [
                                Icon(
                                  data['isActive'] == true
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: data['isActive'] == true
                                      ? Colors.green
                                      : Colors.red,
                                  size: 16,
                                ),
                                Text(
                                  data['isActive'] == true
                                      ? ' Active'
                                      : ' Inactive',
                                  style: TextStyle(
                                    color: data['isActive'] == true
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
                              _handleProviderAction(value, provider.id, data),
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
                                  data['isActive'] == true
                                      ? Icons.block
                                      : Icons.check_circle,
                                ),
                                title: Text(
                                  data['isActive'] == true
                                      ? 'Deactivate'
                                      : 'Activate',
                                ),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'services',
                              child: ListTile(
                                leading: Icon(Icons.work),
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
            ),
          ),
        ],
      ),
    );
  }

  void _handleProviderAction(
    String action,
    String providerId,
    Map<String, dynamic> providerData,
  ) async {
    switch (action) {
      case 'edit':
        _showEditProviderDialog(providerId, providerData);
        break;
      case 'toggle':
        await _toggleProviderStatus(
          providerId,
          providerData['isActive'] ?? false,
        );
        break;
      case 'services':
        _showProviderServices(providerId, providerData['name'] ?? 'Provider');
        break;
      case 'delete':
        _showDeleteProviderConfirmation(
          providerId,
          providerData['name'] ?? 'Provider',
        );
        break;
    }
  }

  void _showAddProviderDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Provider'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Provider Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
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
                  emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                await _createProvider(
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                  passwordController.text,
                );
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Add Provider'),
          ),
        ],
      ),
    );
  }

  void _showEditProviderDialog(
    String providerId,
    Map<String, dynamic> providerData,
  ) {
    final nameController = TextEditingController(
      text: providerData['name'] ?? '',
    );
    final emailController = TextEditingController(
      text: providerData['email'] ?? '',
    );
    final phoneController = TextEditingController(
      text: providerData['phone'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Provider'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Provider Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
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
              await _updateProvider(
                providerId,
                nameController.text,
                emailController.text,
                phoneController.text,
              );
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showProviderServices(String providerId, String providerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$providerName\'s Services'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('services')
                .where('providerId', isEqualTo: providerId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final services = snapshot.data?.docs ?? [];
              if (services.isEmpty) {
                return const Center(
                  child: Text('No services assigned to this provider'),
                );
              }

              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  final data = service.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['name'] ?? 'Unknown Service'),
                    subtitle: Text('\$${data['price']?.toString() ?? '0.00'}'),
                    trailing: Icon(
                      data['isAvailable'] == true
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: data['isAvailable'] == true
                          ? Colors.green
                          : Colors.red,
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

  void _showDeleteProviderConfirmation(String providerId, String providerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Provider'),
        content: Text('Are you sure you want to delete $providerName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _deleteProvider(providerId);
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _createProvider(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      // Create user document in Firestore
      final providerId = _firestore.collection('users').doc().id;

      await _firestore.collection('users').doc(providerId).set({
        'uid': providerId,
        'name': name,
        'email': email,
        'phone': phone,
        'role': 'provider',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'profile': {
          'firstName': name.split(' ').first,
          'lastName': name.split(' ').length > 1 ? name.split(' ').last : '',
          'avatar': '',
        },
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Provider $name added successfully')),
        );
      }

      developer.log(
        'Provider created successfully: $providerId',
        name: 'ProviderManagement',
      );
    } catch (e) {
      developer.log('Error creating provider: $e', name: 'ProviderManagement');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating provider: $e')));
      }
    }
  }

  Future<void> _updateProvider(
    String providerId,
    String name,
    String email,
    String phone,
  ) async {
    try {
      await _firestore.collection('users').doc(providerId).update({
        'name': name,
        'email': email,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
        'profile.firstName': name.split(' ').first,
        'profile.lastName': name.split(' ').length > 1
            ? name.split(' ').last
            : '',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Provider updated successfully')),
        );
      }

      developer.log(
        'Provider updated successfully: $providerId',
        name: 'ProviderManagement',
      );
    } catch (e) {
      developer.log('Error updating provider: $e', name: 'ProviderManagement');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating provider: $e')));
      }
    }
  }

  Future<void> _toggleProviderStatus(
    String providerId,
    bool currentStatus,
  ) async {
    try {
      await _firestore.collection('users').doc(providerId).update({
        'isActive': !currentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Provider ${!currentStatus ? 'activated' : 'deactivated'} successfully',
            ),
          ),
        );
      }

      developer.log(
        'Provider status toggled: $providerId',
        name: 'ProviderManagement',
      );
    } catch (e) {
      developer.log(
        'Error toggling provider status: $e',
        name: 'ProviderManagement',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating provider status: $e')),
        );
      }
    }
  }

  Future<void> _deleteProvider(String providerId) async {
    try {
      await _firestore.collection('users').doc(providerId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Provider deleted successfully')),
        );
      }

      developer.log(
        'Provider deleted successfully: $providerId',
        name: 'ProviderManagement',
      );
    } catch (e) {
      developer.log('Error deleting provider: $e', name: 'ProviderManagement');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting provider: $e')));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
