import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/booking/screens/booking_screen.dart';
import '../features/booking/screens/booking_confirmation_screen.dart';
import '../features/payment/screens/payment_screen.dart';
import '../features/home/screens/search_screen.dart';
import '../features/services/screens/service_details_screen.dart';
import '../features/booking/screens/tracking_screen.dart';
import '../features/booking/screens/bookings_screen.dart';
import '../features/auth/screens/modern_home_screen.dart';
import '../features/provider/screens/provider_list_screen.dart';
import '../features/provider/screens/provider_detail_screen.dart';
import '../models/unified_service_model.dart';
import '../screens/view_all/view_all_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String search = '/search';
  static const String service = '/service';
  static const String booking = '/booking';
  static const String payment = '/payment';
  static const String confirmation = '/confirmation';
  static const String tracking = '/tracking';
  static const String viewAll = '/view-all';
  static const String bookingStatus = '/booking-status';
  static const String bookings = '/bookings';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      search: (context) => const SearchScreen(),
      service: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

        // Convert map to ServiceModel if needed
        final serviceData = args['service'] as Map<String, dynamic>;
        final service = ServiceModel(
          id: serviceData['id'] ?? 'unknown',
          name: serviceData['name'] ?? 'Unknown Service',
          icon: serviceData['icon'] ?? '🛠️',
          description: serviceData['description'] ?? 'No description available',
          imageUrl: serviceData['imageUrl'] ?? '',
          price: (serviceData['price'] as num?)?.toDouble() ?? 0.0,
          category: serviceData['category'] ?? 'general',
          duration: serviceData['duration'] ?? 60,
          isAvailable: serviceData['isAvailable'] ?? true,
          packages: const <ServicePackage>[], // Empty list for now
          rating: (serviceData['rating'] as num?)?.toDouble() ?? 4.5,
          totalReviews: serviceData['totalReviews'] ?? 0,
        );

        return ServiceDetailsScreen(service: service);
      },
      booking: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return BookingScreen(service: args['service']);
      },
      payment: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return PaymentScreen(booking: args['booking']);
      },
      confirmation: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return BookingConfirmationScreen(bookingId: args['bookingId']);
      },
      tracking: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return TrackingScreen(bookingId: args['bookingId']);
      },
      viewAll: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        final category = args?['category'] ?? 'all';
        final title = args?['title'] ?? 'All Services';

        // Generate sample services based on category
        List<Map<String, dynamic>> services =
            _generateServicesForCategory(category);

        return ViewAllScreen(
          title: title,
          services: services,
        );
      },
      bookings: (context) => const BookingsScreen(),
      dashboard: (context) => const ModernHomeScreen(),
      // Add service provider routes
      '/providers': (context) => const ProviderListScreen(),
      '/provider-details': (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return ProviderDetailScreen(providerId: args['providerId']);
      },
    };
  }

  static List<Map<String, dynamic>> _generateServicesForCategory(
      String category) {
    switch (category.toLowerCase()) {
      case 'recommended':
        return [
          {
            'id': 'ac_service',
            'name': 'AC Servicing',
            'price': '৳299',
            'icon': '❄️',
            'color': const Color(0xFF667eea),
            'rating': 4.8,
            'reviews': 203
          },
          {
            'id': 'home_cleaning',
            'name': 'Home Cleaning',
            'price': '৳199',
            'icon': '🧹',
            'color': const Color(0xFF4CAF50),
            'rating': 4.6,
            'reviews': 127
          },
          {
            'id': 'salon_care',
            'name': 'Salon Care',
            'price': '৳149',
            'icon': '💅',
            'color': const Color(0xFFE91E63),
            'rating': 4.9,
            'reviews': 89
          },
          {
            'id': 'driver',
            'name': 'Driver Service',
            'price': '৳12/km',
            'icon': '🚗',
            'color': const Color(0xFFFF9800),
            'rating': 4.7,
            'reviews': 156
          },
        ];
      case 'home':
        return [
          {
            'id': 'plumbing',
            'name': 'Plumbing & Sanitary',
            'price': '৳199',
            'icon': '🔧',
            'color': const Color(0xFF2196F3),
            'rating': 4.5,
            'reviews': 98
          },
          {
            'id': 'house_shifting',
            'name': 'House Shifting',
            'price': '৳1,999',
            'icon': '📦',
            'color': const Color(0xFF9C27B0),
            'rating': 4.6,
            'reviews': 67
          },
          {
            'id': 'home_cleaning_home',
            'name': 'Home Cleaning',
            'price': '৳199',
            'icon': '🧽',
            'color': const Color(0xFF4CAF50),
            'rating': 4.6,
            'reviews': 127
          },
          {
            'id': 'painting',
            'name': 'Painting Services',
            'price': '৳8/sq ft',
            'icon': '🎨',
            'color': const Color(0xFFFF5722),
            'rating': 4.8,
            'reviews': 234
          },
        ];
      case 'trending':
        return [
          {
            'id': 'ac_service_trending',
            'name': 'AC Servicing',
            'price': '৳299',
            'icon': '❄️',
            'color': const Color(0xFF667eea),
            'rating': 4.8,
            'reviews': 203
          },
          {
            'id': 'home_cleaning_trending',
            'name': 'Home Cleaning',
            'price': '৳199',
            'icon': '🧹',
            'color': const Color(0xFF4CAF50),
            'rating': 4.6,
            'reviews': 127
          },
          {
            'id': 'furniture_cleaning',
            'name': 'Furniture Cleaning',
            'price': '৳99',
            'icon': '🪑',
            'color': const Color(0xFF795548),
            'rating': 4.4,
            'reviews': 78
          },
          {
            'id': 'house_shifting_trending',
            'name': 'House Shifting',
            'price': '৳1,999',
            'icon': '🏠',
            'color': const Color(0xFF9C27B0),
            'rating': 4.6,
            'reviews': 67
          },
        ];
      default:
        return [
          {
            'id': 'ac_service_all',
            'name': 'AC Servicing',
            'price': '৳299',
            'icon': '❄️',
            'color': const Color(0xFF667eea),
            'rating': 4.8,
            'reviews': 203
          },
          {
            'id': 'home_cleaning_all',
            'name': 'Home Cleaning',
            'price': '৳199',
            'icon': '🧹',
            'color': const Color(0xFF4CAF50),
            'rating': 4.6,
            'reviews': 127
          },
          {
            'id': 'plumbing_all',
            'name': 'Plumbing & Sanitary',
            'price': '৳199',
            'icon': '🔧',
            'color': const Color(0xFF2196F3),
            'rating': 4.5,
            'reviews': 98
          },
          {
            'id': 'painting_all',
            'name': 'Painting Services',
            'price': '৳8/sq ft',
            'icon': '🎨',
            'color': const Color(0xFFFF5722),
            'rating': 4.8,
            'reviews': 234
          },
          {
            'id': 'driver_all',
            'name': 'Driver Service',
            'price': '৳12/km',
            'icon': '🚗',
            'color': const Color(0xFFFF9800),
            'rating': 4.7,
            'reviews': 156
          },
          {
            'id': 'salon_care_all',
            'name': 'Salon Care',
            'price': '৳149',
            'icon': '💅',
            'color': const Color(0xFFE91E63),
            'rating': 4.9,
            'reviews': 89
          },
        ];
    }
  }
}
