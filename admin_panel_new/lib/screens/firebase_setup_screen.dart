import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/firebase_admin_setup.dart';

class FirebaseSetupScreen extends StatefulWidget {
  const FirebaseSetupScreen({super.key});

  @override
  State<FirebaseSetupScreen> createState() => _FirebaseSetupScreenState();
}

class _FirebaseSetupScreenState extends State<FirebaseSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createAdminUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _statusMessage = null;
      _isSuccess = false;
    });

    try {
      final success = await FirebaseAdminSetup.createAdminUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
      );

      if (success) {
        setState(() {
          _statusMessage =
              'Admin user created successfully! You can now sign in.';
          _isSuccess = true;
        });

        // Also create sample data
        await FirebaseAdminSetup.createSampleData();

        developer.log(
          'Admin setup completed successfully',
          name: 'FirebaseSetupScreen',
        );
      } else {
        setState(() {
          _statusMessage =
              'Failed to create admin user. Please check the logs.';
          _isSuccess = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
        _isSuccess = false;
      });

      developer.log(
        'Error in admin setup: $e',
        name: 'FirebaseSetupScreen',
        error: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _promoteCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _statusMessage = 'No user is currently signed in.';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
      _isSuccess = false;
    });

    try {
      final success = await FirebaseAdminSetup.promoteToAdmin(user.uid);

      if (success) {
        setState(() {
          _statusMessage = 'Current user promoted to admin successfully!';
          _isSuccess = true;
        });
      } else {
        setState(() {
          _statusMessage = 'Failed to promote current user to admin.';
          _isSuccess = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: ${e.toString()}';
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Admin Setup'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔧 Firebase Admin Panel Setup',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This utility will help you set up the admin authentication for your Firebase backend. '
                      'Follow the steps below to get your admin panel working properly.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Step 1: Firestore Rules
            _buildStepCard(
              '1',
              'Update Firestore Security Rules',
              'First, update your Firestore security rules to allow admin setup.',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. Go to Firebase Console → Firestore Database → Rules\n'
                    '2. Replace the current rules with the temporary rules below:\n'
                    '3. Click "Publish" to save the changes',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Temporary Security Rules:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: () => _copyToClipboard(
                                FirebaseAdminSetup.getTemporarySecurityRules(),
                              ),
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('Copy'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            FirebaseAdminSetup.getTemporarySecurityRules(),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Step 2: Create Admin User
            _buildStepCard(
              '2',
              'Create Admin User',
              'Create the first admin user account.',
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Admin Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter admin name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Admin Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Admin Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      obscureText: !_showPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createAdminUser,
                        child: _isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Creating Admin User...'),
                                ],
                              )
                            : const Text('Create Admin User'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Alternative: Promote Current User
            _buildStepCard(
              '2B',
              'Or Promote Current User',
              'If you already have a user account, promote it to admin instead.',
              Column(
                children: [
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      final user = snapshot.data;
                      if (user == null) {
                        return const Text('No user currently signed in.');
                      }
                      return Column(
                        children: [
                          Text('Current user: ${user.email}'),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _promoteCurrentUser,
                              child: const Text(
                                'Promote Current User to Admin',
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Status Message
            if (_statusMessage != null)
              Card(
                color: _isSuccess ? Colors.green[50] : Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle : Icons.error,
                        color: _isSuccess ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _statusMessage!,
                          style: TextStyle(
                            color: _isSuccess
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Step 3: Restore Security Rules
            _buildStepCard(
              '3',
              'Restore Production Security Rules',
              'After creating the admin user, restore the secure production rules.',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. Go back to Firebase Console → Firestore Database → Rules\n'
                    '2. Replace with the production rules below:\n'
                    '3. Click "Publish" to save the secure rules',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Production Security Rules:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: () => _copyToClipboard(
                                FirebaseAdminSetup.getProductionSecurityRules(),
                              ),
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('Copy'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 200,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              FirebaseAdminSetup.getProductionSecurityRules(),
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Step 4: Create Indexes
            _buildStepCard(
              '4',
              'Create Firestore Indexes',
              'Create the required composite indexes for complex queries.',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'The admin panel uses complex queries that require composite indexes. '
                    'When you run the app, Firebase will show error messages with direct links to create these indexes.\n\n'
                    'Typical indexes needed:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Bookings: status + createdAt (descending)'),
                        Text('• Users: role + createdAt (descending)'),
                        Text('• Providers: isActive + rating (descending)'),
                        Text('• Services: category + isActive + createdAt'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Click the index creation links when they appear in the browser console, '
                    'or create them manually in Firebase Console → Firestore → Indexes.',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Final Instructions
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✅ Setup Complete!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'After completing all steps above:\n\n'
                      '1. Sign in with your admin credentials\n'
                      '2. The admin panel should now work properly\n'
                      '3. All Firebase permission errors should be resolved\n'
                      '4. Create additional indexes as needed when prompted',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
    String stepNumber,
    String title,
    String description,
    Widget content,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      stepNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}
