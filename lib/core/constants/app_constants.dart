class AppConstants {
  // API endpoints
  static const String baseUrl = 'your-api-base-url';

  // Asset paths
  static const String imagesPath = 'assets/images';
  static const String iconsPath = 'assets/icons';

  // Shared preferences keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';

  // Firebase collections
  static const String usersCollection = 'users';
  static const String servicesCollection = 'services';
  static const String bookingsCollection = 'bookings';
  static const String providersCollection = 'providers';

  // Default values
  static const int defaultPageSize = 10;
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
}
