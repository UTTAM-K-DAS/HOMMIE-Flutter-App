// App Constants
class AppConstants {
  // App Information
  static const String appName = 'HOMMIE';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your complete home services solution';

  // API Constants
  static const String baseUrl = 'https://api.hommie.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String servicesCollection = 'services';
  static const String bookingsCollection = 'bookings';
  static const String providersCollection = 'providers';
  static const String reviewsCollection = 'reviews';
  static const String paymentsCollection = 'payments';

  // SharedPreferences Keys
  static const String keyIsFirstTime = 'is_first_time';
  static const String keyUserData = 'user_data';
  static const String keyAuthToken = 'auth_token';
  static const String keySelectedLanguage = 'selected_language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // Default Values
  static const String defaultProfileImage =
      'https://via.placeholder.com/150x150/607D8B/FFFFFF?text=User';
  static const String defaultServiceImage =
      'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Service';
  static const String defaultCurrency = '৳';
  static const String defaultLanguage = 'en';
  static const String defaultCountryCode = '+880';

  // Service Categories
  static const List<String> serviceCategories = [
    'AC Services',
    'Home Cleaning',
    'Beauty & Salon',
    'Plumbing',
    'Electrical',
    'House Shifting',
    'Painting',
    'Gas Stove Services',
    'Driver Services',
    'Appliance Repair',
  ];

  // Payment Methods
  static const List<String> paymentMethods = [
    'Cash on Delivery',
    'bKash',
    'Nagad',
    'Rocket',
    'Credit Card',
    'Bank Transfer',
  ];

  // Booking Status
  static const String bookingPending = 'pending';
  static const String bookingConfirmed = 'confirmed';
  static const String bookingInProgress = 'in_progress';
  static const String bookingCompleted = 'completed';
  static const String bookingCancelled = 'cancelled';

  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleProvider = 'provider';
  static const String roleAdmin = 'admin';

  // Image Paths
  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';
  static const String animationPath = 'assets/animations/';

  // Font Families
  static const String fontFamily = 'Poppins';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int maxAddressLength = 200;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Map
  static const double defaultLatitude = 23.8103;
  static const double defaultLongitude = 90.4125;
  static const double defaultZoom = 15.0;

  // Time
  static const List<String> timeSlots = [
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
  ];

  // Rating
  static const double maxRating = 5.0;
  static const double minRating = 1.0;

  // Distance
  static const double maxServiceRadius = 50.0; // km
  static const double defaultServiceRadius = 10.0; // km

  // File Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp'
  ];

  // Error Messages
  static const String errorNetworkConnection = 'No internet connection';
  static const String errorSomethingWentWrong = 'Something went wrong';
  static const String errorInvalidCredentials = 'Invalid email or password';
  static const String errorUserNotFound = 'User not found';
  static const String errorEmailAlreadyInUse = 'Email already in use';
  static const String errorWeakPassword = 'Password is too weak';
  static const String errorInvalidEmail = 'Invalid email address';

  // Success Messages
  static const String successLogin = 'Login successful';
  static const String successSignup = 'Account created successfully';
  static const String successBooking = 'Booking confirmed successfully';
  static const String successPayment = 'Payment completed successfully';
  static const String successProfileUpdate = 'Profile updated successfully';

  // URLs
  static const String privacyPolicyUrl = 'https://hommie.com/privacy';
  static const String termsOfServiceUrl = 'https://hommie.com/terms';
  static const String supportUrl = 'https://hommie.com/support';
  static const String faqUrl = 'https://hommie.com/faq';

  // Contact Information
  static const String supportEmail = 'support@hommie.com';
  static const String supportPhone = '+8801XXXXXXXXX';
  static const String supportWhatsApp = '+8801XXXXXXXXX';

  // Social Media
  static const String facebookUrl = 'https://facebook.com/hommie';
  static const String twitterUrl = 'https://twitter.com/hommie';
  static const String instagramUrl = 'https://instagram.com/hommie';
  static const String linkedinUrl = 'https://linkedin.com/company/hommie';

  // Notification Types
  static const String notificationBooking = 'booking';
  static const String notificationPayment = 'payment';
  static const String notificationPromotion = 'promotion';
  static const String notificationGeneral = 'general';

  // Image Quality
  static const int imageQualityHigh = 100;
  static const int imageQualityMedium = 75;
  static const int imageQualityLow = 50;

  // Cache
  static const int cacheExpiryDays = 7;
  static const String cacheImagePrefix = 'img_';
  static const String cacheDataPrefix = 'data_';
}
