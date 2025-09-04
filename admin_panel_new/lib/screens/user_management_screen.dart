import 'package:flutter/material.dart';
import '../services/user_management_service.dart';
import '../models/user_model.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with SingleTickerProviderStateMixin {
  final UserManagementService _userService = UserManagementService();
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All Users'),
            Tab(text: 'Customers'),
            Tab(text: 'Providers'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showUserStats,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserList(null), // All users
          _buildUserList('customer'),
          _buildUserList('provider'),
        ],
      ),
    );
  }

  Widget _buildUserList(String? role) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search Users',
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
        // Users List
        Expanded(
          child: StreamBuilder<List<UserModel>>(
            stream: _searchQuery.isNotEmpty
                ? _userService.searchUsers(_searchQuery)
                : (role == null
                      ? _userService.getUsers()
                      : _userService.getUsersByRole(role)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final users = snapshot.data ?? [];

              // Filter by role if searching
              final filteredUsers = _searchQuery.isNotEmpty && role != null
                  ? users.where((user) => user.role == role).toList()
                  : users;

              if (filteredUsers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No ${role ?? ''} users found',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: _getRoleColor(user.role),
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : null,
                          child: user.photoURL == null
                              ? Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.email),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(
                                      user.role,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user.role.toUpperCase(),
                                    style: TextStyle(
                                      color: _getRoleColor(user.role),
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
                                    color: user.isActive
                                        ? Colors.green.withValues(alpha: 0.1)
                                        : Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user.isActive ? 'ACTIVE' : 'INACTIVE',
                                    style: TextStyle(
                                      color: user.isActive
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) => _handleUserAction(value, user),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),
                            ),
                            PopupMenuItem(
                              value: user.isActive ? 'deactivate' : 'activate',
                              child: ListTile(
                                leading: Icon(
                                  user.isActive
                                      ? Icons.block
                                      : Icons.check_circle,
                                ),
                                title: Text(
                                  user.isActive ? 'Deactivate' : 'Activate',
                                ),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'role',
                              child: ListTile(
                                leading: Icon(Icons.person_outline),
                                title: Text('Change Role'),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'details',
                              child: ListTile(
                                leading: Icon(Icons.info),
                                title: Text('View Details'),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (user.phone != null) ...[
                                  _buildDetailRow('Phone', user.phone!),
                                ],
                                if (user.address != null) ...[
                                  _buildDetailRow('Address', user.address!),
                                ],
                                if (user.createdAt != null) ...[
                                  _buildDetailRow(
                                    'Joined',
                                    _formatDateTime(user.createdAt!),
                                  ),
                                ],
                                if (user.lastLogin != null) ...[
                                  _buildDetailRow(
                                    'Last Login',
                                    _formatDateTime(user.lastLogin!),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          _showEditUserDialog(user),
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Edit'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () => _toggleUserStatus(user),
                                      icon: Icon(
                                        user.isActive
                                            ? Icons.block
                                            : Icons.check_circle,
                                      ),
                                      label: Text(
                                        user.isActive
                                            ? 'Deactivate'
                                            : 'Activate',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: user.isActive
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'provider':
        return Colors.orange;
      case 'customer':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _handleUserAction(String action, UserModel user) async {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'activate':
      case 'deactivate':
        _toggleUserStatus(user);
        break;
      case 'role':
        _showChangeRoleDialog(user);
        break;
      case 'details':
        _showUserDetails(user);
        break;
    }
  }

  void _toggleUserStatus(UserModel user) async {
    try {
      await _userService.toggleUserStatus(user.id, !user.isActive);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User ${user.isActive ? 'deactivated' : 'activated'} successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating user status: $e')),
        );
      }
    }
  }

  void _showEditUserDialog(UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final addressController = TextEditingController(text: user.address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: false, // Don't allow email changes
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 3,
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
              final updatedUser = UserModel(
                id: user.id,
                name: nameController.text,
                email: user.email, // Keep original email
                phone: phoneController.text.isNotEmpty
                    ? phoneController.text
                    : null,
                address: addressController.text.isNotEmpty
                    ? addressController.text
                    : null,
                photoURL: user.photoURL,
                createdAt: user.createdAt,
                lastLogin: user.lastLogin,
                isActive: user.isActive,
                role: user.role,
              );

              await _userService.updateUser(user.id, updatedUser);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User updated successfully')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showChangeRoleDialog(UserModel user) {
    String selectedRole = user.role;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Role for ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Customer'),
              value: 'customer',
              groupValue: selectedRole,
              onChanged: (value) {
                selectedRole = value!;
                Navigator.pop(context);
                _updateUserRole(user, selectedRole);
              },
            ),
            RadioListTile<String>(
              title: const Text('Provider'),
              value: 'provider',
              groupValue: selectedRole,
              onChanged: (value) {
                selectedRole = value!;
                Navigator.pop(context);
                _updateUserRole(user, selectedRole);
              },
            ),
            RadioListTile<String>(
              title: const Text('Admin'),
              value: 'admin',
              groupValue: selectedRole,
              onChanged: (value) {
                selectedRole = value!;
                Navigator.pop(context);
                _updateUserRole(user, selectedRole);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _updateUserRole(UserModel user, String newRole) async {
    try {
      await _userService.updateUserRole(user.id, newRole);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User role updated to $newRole')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating user role: $e')));
      }
    }
  }

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${user.name} Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', user.id),
              _buildDetailRow('Name', user.name),
              _buildDetailRow('Email', user.email),
              _buildDetailRow('Phone', user.phone ?? 'N/A'),
              _buildDetailRow('Address', user.address ?? 'N/A'),
              _buildDetailRow('Role', user.role),
              _buildDetailRow('Status', user.isActive ? 'Active' : 'Inactive'),
              if (user.createdAt != null)
                _buildDetailRow('Joined', _formatDateTime(user.createdAt!)),
              if (user.lastLogin != null)
                _buildDetailRow('Last Login', _formatDateTime(user.lastLogin!)),
            ],
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

  void _showUserStats() async {
    final stats = await _userService.getUserStats();

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('User Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatRow('Total Users', stats['totalUsers'].toString()),
              _buildStatRow('Customers', stats['customers'].toString()),
              _buildStatRow('Providers', stats['providers'].toString()),
              _buildStatRow('Active Users', stats['activeUsers'].toString()),
            ],
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
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 18)),
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
