import 'dart:developer' as developer;

class AppConfig {
  // App Information
  static const String appName = 'HOMMIE Admin Panel';
  static const String appVersion = '1.0.0+1';
  static const String appDescription =
      'Professional home service management platform';

  // Build Configuration
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const bool isDebug = !isProduction;

  // API Configuration
  static const String baseApiUrl = 'https://api.hommie.com/v1';
  static const String websocketUrl = 'wss://api.hommie.com/ws';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Firebase Configuration
  static const String firebaseProjectId = 'hommie-admin-panel';
  static const String firebaseStorageBucket = 'hommie-admin-panel.appspot.com';

  // Security Configuration
  static const int maxLoginAttempts = 5;
  static const Duration sessionTimeout = Duration(hours: 8);
  static const Duration passwordResetTimeout = Duration(minutes: 15);
  static const int minPasswordLength = 8;

  // File Upload Configuration
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
  ];
  static const List<String> allowedDocumentTypes = [
    '.pdf',
    '.doc',
    '.docx',
    '.txt',
  ];

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Pagination Configuration
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Configuration
  static const Duration cacheExpiry = Duration(hours: 1);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB

  // Notification Configuration
  static const String notificationChannelId = 'admin_notifications';
  static const String notificationChannelName = 'Admin Notifications';
  static const String notificationChannelDescription =
      'Notifications for admin panel';

  // Analytics Configuration
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = isProduction;
  static const bool enablePerformanceMonitoring = true;

  // Feature Flags
  static const bool enableDarkMode = true;
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = true;
  static const bool enableAdvancedAnalytics = true;

  // Development Configuration
  static const bool showDebugBanner = !isProduction;
  static const bool enableLogging = true;
  static const bool enableInspector = isDebug;

  // Rate Limiting
  static const Map<String, int> rateLimits = {
    'login': 5, // per minute
    'password_reset': 3, // per minute
    'api_call': 60, // per minute
    'file_upload': 10, // per minute
    'notification_send': 20, // per minute
  };

  // Error Handling
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const bool showDetailedErrors = isDebug;

  // Backup Configuration
  static const bool enableAutoBackup = true;
  static const Duration backupInterval = Duration(hours: 24);
  static const int maxBackupFiles = 30;

  // Performance Configuration
  static const int connectionPoolSize = 10;
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration readTimeout = Duration(seconds: 30);
  static const Duration writeTimeout = Duration(seconds: 30);

  // Localization
  static const String defaultLocale = 'en';
  static const List<String> supportedLocales = ['en', 'es', 'fr', 'de'];

  // Theme Configuration
  static const String defaultTheme = 'light';
  static const String fontFamily = 'Poppins';

  // Database Configuration
  static const int dbVersion = 1;
  static const String dbName = 'hommie_admin.db';

  // Sync Configuration
  static const Duration syncInterval = Duration(minutes: 5);
  static const bool enableAutoSync = true;
  static const int maxSyncRetries = 3;

  // Content Configuration
  static const String termsOfServiceUrl = 'https://hommie.com/terms';
  static const String privacyPolicyUrl = 'https://hommie.com/privacy';
  static const String supportEmail = 'support@hommie.com';
  static const String supportPhone = '+1-800-HOMMIE';

  // Social Media Links
  static const Map<String, String> socialMediaLinks = {
    'facebook': 'https://facebook.com/hommie',
    'twitter': 'https://twitter.com/hommie',
    'instagram': 'https://instagram.com/hommie',
    'linkedin': 'https://linkedin.com/company/hommie',
  };

  // App Store Links
  static const Map<String, String> appStoreLinks = {
    'android': 'https://play.google.com/store/apps/details?id=com.hommie.app',
    'ios': 'https://apps.apple.com/app/hommie/id123456789',
  };

  // Environment-specific configurations
  static Map<String, dynamic> get environmentConfig {
    if (isProduction) {
      return {
        'apiUrl': 'https://api.hommie.com/v1',
        'logLevel': 'ERROR',
        'enableDebug': false,
        'enableMockData': false,
      };
    } else {
      return {
        'apiUrl': 'https://dev-api.hommie.com/v1',
        'logLevel': 'DEBUG',
        'enableDebug': true,
        'enableMockData': true,
      };
    }
  }

  // Get configuration value with fallback
  static T getConfig<T>(String key, T defaultValue) {
    try {
      final config = environmentConfig;
      return config.containsKey(key) ? config[key] as T : defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // Validate configuration
  static bool isConfigValid() {
    try {
      // Validate critical configurations
      if (baseApiUrl.isEmpty) return false;
      if (firebaseProjectId.isEmpty) return false;
      if (maxLoginAttempts <= 0) return false;
      if (sessionTimeout.inMinutes <= 0) return false;
      if (minPasswordLength < 6) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get feature flag value
  static bool isFeatureEnabled(String feature) {
    switch (feature) {
      case 'dark_mode':
        return enableDarkMode;
      case 'offline_mode':
        return enableOfflineMode;
      case 'push_notifications':
        return enablePushNotifications;
      case 'biometric_auth':
        return enableBiometricAuth;
      case 'advanced_analytics':
        return enableAdvancedAnalytics;
      default:
        return false;
    }
  }

  // Get rate limit for action
  static int getRateLimit(String action) {
    return rateLimits[action] ?? 10;
  }

  // Print configuration summary (for debugging)
  static void printConfigSummary() {
    if (!isDebug) return;

    developer.log(
      '=== HOMMIE Admin Panel Configuration ===',
      name: 'AppConfig',
    );
    developer.log('App Name: $appName', name: 'AppConfig');
    developer.log('Version: $appVersion', name: 'AppConfig');
    developer.log(
      'Environment: ${isProduction ? "Production" : "Development"}',
      name: 'AppConfig',
    );
    developer.log('API URL: $baseApiUrl', name: 'AppConfig');
    developer.log('Firebase Project: $firebaseProjectId', name: 'AppConfig');
    developer.log('Debug Mode: $isDebug', name: 'AppConfig');
    developer.log('Analytics Enabled: $enableAnalytics', name: 'AppConfig');
    developer.log(
      '========================================',
      name: 'AppConfig',
    );
  }
}
