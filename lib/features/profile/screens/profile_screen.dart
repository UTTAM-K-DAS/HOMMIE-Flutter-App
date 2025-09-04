import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userModel;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null
                    ? Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Name'),
              subtitle: Text(user.name),
              trailing: const Icon(Icons.edit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final controller = TextEditingController(text: user.name);
                    return AlertDialog(
                      title: const Text('Edit Name'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: 'Name'),
                        autofocus: true,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              authProvider.updateProfile(
                                  name: controller.text.trim());
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(user.email),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(user.phone ?? 'Not set'),
              trailing: const Icon(Icons.edit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final controller = TextEditingController(text: user.phone);
                    return AlertDialog(
                      title: const Text('Edit Phone Number'),
                      content: TextField(
                        controller: controller,
                        decoration:
                            const InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        autofocus: true,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              authProvider.updateProfile(
                                  phone: controller.text.trim());
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final currentPasswordController = TextEditingController();
                    final newPasswordController = TextEditingController();
                    final formKey = GlobalKey<FormState>();

                    return AlertDialog(
                      title: const Text('Change Password'),
                      content: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: currentPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Current Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your current password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: newPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'New Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a new password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                await authProvider.updatePassword(
                                  currentPasswordController.text,
                                  newPasswordController.text,
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Password updated successfully'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text('Update'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text(
                      'Are you sure you want to delete your account? This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          authProvider.deleteAccount();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
