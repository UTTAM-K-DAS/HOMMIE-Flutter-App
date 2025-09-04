import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../services/error_handling_service.dart';
import '../services/network_service.dart';
import '../services/analytics_service.dart';
import '../services/theme_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../services/security_service.dart';
import '../services/validation_service.dart';
import '../services/user_management_service.dart';
import '../services/service_management_service.dart';
import '../services/provider_service.dart';

class ServiceManager {
  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;
  ServiceManager._internal();

  // Service instances
  late final ErrorHandlingService errorHandling;
  late final NetworkService network;
  late final AnalyticsService analytics;
  late final ThemeService theme;
  late final NotificationService notification;
  late final StorageService storage;
  late final SecurityService security;
  late final UserManagementService userManagement;
  late final ServiceManagementService serviceManagement;
  late final ProviderService provider;

  bool _isInitialized = false;

  // Initialize all services
  Future<void> initializeServices() async {
    if (_isInitialized) return;

    try {
      // Initialize core services first
      errorHandling = ErrorHandlingService();
      network = NetworkService();
      security = SecurityService();

      // Initialize data services
      analytics = AnalyticsService();
      storage = StorageService();
      userManagement = UserManagementService();
      serviceManagement = ServiceManagementService();
      provider = ProviderService();

      // Initialize UI services
      theme = ThemeService();
      notification = NotificationService();

      // Initialize services that require async setup
      await theme.initialize();
      await notification.initialize();

      _isInitialized = true;
      developer.log(
        '✅ All services initialized successfully',
        name: 'ServiceManager',
      );
    } catch (e) {
      developer.log(
        '❌ Error initializing services: $e',
        name: 'ServiceManager',
      );
      rethrow;
    }
  }

  // Get error handling service
  ErrorHandlingService get errorService => errorHandling;

  // Get network service
  NetworkService get networkService => network;

  // Get analytics service
  AnalyticsService get analyticsService => analytics;

  // Get theme service
  ThemeService get themeService => theme;

  // Get notification service
  NotificationService get notificationService => notification;

  // Get storage service
  StorageService get storageService => storage;

  // Get security service
  SecurityService get securityService => security;

  // Get user management service
  UserManagementService get userService => userManagement;

  // Get service management service
  ServiceManagementService get serviceService => serviceManagement;

  // Get provider service
  ProviderService get providerService => provider;

  // Check if services are initialized
  bool get isInitialized => _isInitialized;

  // Restart all services
  Future<void> restartServices() async {
    _isInitialized = false;
    await initializeServices();
  }
}

// Service locator pattern for easy access
class Services {
  static ServiceManager get manager => ServiceManager();

  static ErrorHandlingService get error => manager.errorService;
  static NetworkService get network => manager.networkService;
  static AnalyticsService get analytics => manager.analyticsService;
  static ThemeService get theme => manager.themeService;
  static NotificationService get notification => manager.notificationService;
  static StorageService get storage => manager.storageService;
  static SecurityService get security => manager.securityService;
  static UserManagementService get user => manager.userService;
  static ServiceManagementService get service => manager.serviceService;
  static ProviderService get provider => manager.providerService;

  // Validation service is stateless, so we can use it directly
  static ValidationService get validation => ValidationService();
}

// Custom service-aware widget
abstract class ServiceAwareWidget extends StatefulWidget {
  const ServiceAwareWidget({super.key});
}

abstract class ServiceAwareState<T extends ServiceAwareWidget>
    extends State<T> {
  @override
  void initState() {
    super.initState();
    _ensureServicesInitialized();
  }

  Future<void> _ensureServicesInitialized() async {
    if (!Services.manager.isInitialized) {
      await Services.manager.initializeServices();
      if (mounted) {
        setState(() {});
      }
    }
  }

  // Convenient access to services
  ErrorHandlingService get errorService => Services.error;
  NetworkService get networkService => Services.network;
  AnalyticsService get analyticsService => Services.analytics;
  ThemeService get themeService => Services.theme;
  NotificationService get notificationService => Services.notification;
  StorageService get storageService => Services.storage;
  SecurityService get securityService => Services.security;
  UserManagementService get userService => Services.user;
  ServiceManagementService get serviceService => Services.service;
  ProviderService get providerService => Services.provider;
  ValidationService get validationService => Services.validation;
}

// Service initialization widget
class ServiceInitializer extends StatefulWidget {
  final Widget child;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const ServiceInitializer({
    super.key,
    required this.child,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<ServiceInitializer> createState() => _ServiceInitializerState();
}

class _ServiceInitializerState extends State<ServiceInitializer> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      await Services.manager.initializeServices();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ?? const _DefaultLoadingWidget();
    }

    if (_error != null) {
      return widget.errorWidget ?? _DefaultErrorWidget(error: _error!);
    }

    return widget.child;
  }
}

class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing Services...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  final String error;

  const _DefaultErrorWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Service Initialization Failed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Restart the app or retry initialization
                Services.manager.restartServices();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
