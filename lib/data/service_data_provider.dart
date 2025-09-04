import '../models/unified_service_model.dart';

class ServiceDataProvider {
  static List<ServiceModel> getAllServices() {
    return [
      // AC Servicing Services
      ServiceModel(
        id: 'ac_basic',
        name: 'AC Basic Service',
        icon: '❄️',
        description: 'Basic AC cleaning and maintenance',
        imageUrl: 'https://picsum.photos/300/200?random=1',
        price: 299,
        category: 'AC Service',
        duration: 60,
        packages: [
          ServicePackage(
            name: 'Basic Service',
            description: 'Cleaning, filter replacement',
            price: 299,
          ),
          ServicePackage(
            name: 'Deep Service',
            description: 'Complete overhaul and gas check',
            price: 599,
          ),
          ServicePackage(
            name: 'Premium Service',
            description: 'Full service with 3-month warranty',
            price: 799,
          ),
        ],
        rating: 4.6,
        totalReviews: 1250,
      ),

      // Home Cleaning Services
      ServiceModel(
        id: 'home_cleaning_basic',
        name: 'Home Cleaning',
        icon: '🧹',
        description: 'Professional home cleaning services',
        imageUrl: 'https://picsum.photos/300/200?random=2',
        price: 199,
        category: 'Cleaning',
        duration: 120,
        packages: [
          ServicePackage(
            name: 'Basic Cleaning',
            description: '1-2 rooms, bathroom cleaning',
            price: 199,
          ),
          ServicePackage(
            name: 'Standard Cleaning',
            description: '3-4 rooms, kitchen included',
            price: 399,
          ),
          ServicePackage(
            name: 'Deep Cleaning',
            description: 'Entire home with appliances',
            price: 599,
          ),
        ],
        rating: 4.8,
        totalReviews: 2100,
      ),

      // Plumbing Services
      ServiceModel(
        id: 'plumbing_basic',
        name: 'Plumbing Service',
        icon: '🔧',
        description: 'Expert plumbing solutions',
        imageUrl: 'https://picsum.photos/300/200?random=3',
        price: 199,
        category: 'Plumbing',
        duration: 60,
        packages: [
          ServicePackage(
            name: 'Basic Repair',
            description: 'Tap, pipe minor repairs',
            price: 199,
          ),
          ServicePackage(
            name: 'Standard Service',
            description: 'Multiple fixtures repair',
            price: 399,
          ),
          ServicePackage(
            name: 'Complete Service',
            description: 'Full bathroom/kitchen plumbing',
            price: 699,
          ),
        ],
        rating: 4.5,
        totalReviews: 1800,
      ),

      // Electrical Services
      ServiceModel(
        id: 'electrical_basic',
        name: 'Electrical Service',
        icon: '⚡',
        description: 'Professional electrical services',
        imageUrl: 'https://picsum.photos/300/200?random=4',
        price: 99,
        category: 'Electrical',
        duration: 45,
        packages: [
          ServicePackage(
            name: 'Basic Repair',
            description: 'Switch, socket repairs',
            price: 99,
          ),
          ServicePackage(
            name: 'Wiring Service',
            description: 'Room wiring and installation',
            price: 299,
          ),
          ServicePackage(
            name: 'Complete Setup',
            description: 'Full home electrical work',
            price: 599,
          ),
        ],
        rating: 4.4,
        totalReviews: 950,
      ),

      // House Shifting
      ServiceModel(
        id: 'house_shifting',
        name: 'House Shifting',
        icon: '📦',
        description: 'Complete house moving service',
        imageUrl: 'https://picsum.photos/300/200?random=5',
        price: 1999,
        category: 'Shifting',
        duration: 480,
        packages: [
          ServicePackage(
            name: '1 BHK Shifting',
            description: 'Complete 1 bedroom home',
            price: 1999,
          ),
          ServicePackage(
            name: '2 BHK Shifting',
            description: 'Complete 2 bedroom home',
            price: 2999,
          ),
          ServicePackage(
            name: '3+ BHK Shifting',
            description: '3+ bedroom with storage',
            price: 4999,
          ),
        ],
        rating: 4.3,
        totalReviews: 780,
      ),

      // Painting Services
      ServiceModel(
        id: 'painting_service',
        name: 'Painting Service',
        icon: '🎨',
        description: 'Professional painting services',
        imageUrl: 'https://picsum.photos/300/200?random=6',
        price: 8, // per sq ft
        category: 'Painting',
        duration: 360,
        packages: [
          ServicePackage(
            name: 'Wall Painting',
            description: '৳8 per sq ft - interior walls',
            price: 8,
          ),
          ServicePackage(
            name: 'Full Room',
            description: '৳12 per sq ft - complete room',
            price: 12,
          ),
          ServicePackage(
            name: 'Premium Finish',
            description: '৳15 per sq ft - premium paints',
            price: 15,
          ),
        ],
        rating: 4.7,
        totalReviews: 1450,
      ),

      // Gas Stove Services
      ServiceModel(
        id: 'gas_stove_service',
        name: 'Gas Stove Service',
        icon: '🔥',
        description: 'Gas stove repair and maintenance',
        imageUrl: 'https://picsum.photos/300/200?random=7',
        price: 149,
        category: 'Appliance',
        duration: 30,
        packages: [
          ServicePackage(
            name: 'Basic Service',
            description: 'Cleaning and minor repairs',
            price: 149,
          ),
          ServicePackage(
            name: 'Part Replacement',
            description: 'Replace burner or regulator',
            price: 299,
          ),
          ServicePackage(
            name: 'Complete Overhaul',
            description: 'Full service with warranty',
            price: 499,
          ),
        ],
        rating: 4.5,
        totalReviews: 680,
      ),

      // Beauty/Salon Services
      ServiceModel(
        id: 'beauty_service',
        name: 'Beauty & Salon',
        icon: '💄',
        description: 'Professional beauty services at home',
        imageUrl: 'https://picsum.photos/300/200?random=8',
        price: 149,
        category: 'Beauty',
        duration: 90,
        packages: [
          ServicePackage(
            name: 'Basic Facial',
            description: 'Cleansing and basic facial',
            price: 149,
          ),
          ServicePackage(
            name: 'Hair Service',
            description: 'Cut, wash and styling',
            price: 299,
          ),
          ServicePackage(
            name: 'Bridal Package',
            description: 'Complete bridal makeup',
            price: 1999,
          ),
        ],
        rating: 4.9,
        totalReviews: 2300,
      ),

      // Driver Services
      ServiceModel(
        id: 'driver_service',
        name: 'Driver Service',
        icon: '🚗',
        description: 'Professional driver services',
        imageUrl: 'https://picsum.photos/300/200?random=9',
        price: 12, // per km
        category: 'Transport',
        duration: 60,
        packages: [
          ServicePackage(
            name: 'Hourly Service',
            description: '৳150 per hour within city',
            price: 150,
          ),
          ServicePackage(
            name: 'Daily Service',
            description: '৳1200 per day (8 hours)',
            price: 1200,
          ),
          ServicePackage(
            name: 'Distance Based',
            description: '৳12 per km + waiting charges',
            price: 12,
          ),
        ],
        rating: 4.2,
        totalReviews: 890,
      ),

      // Additional services
      ServiceModel(
        id: 'deep_cleaning',
        name: 'Deep Cleaning',
        icon: '🧽',
        description: 'Thorough deep cleaning service',
        imageUrl: 'https://picsum.photos/300/200?random=10',
        price: 399,
        category: 'Cleaning',
        duration: 240,
        packages: [
          ServicePackage(
            name: 'Kitchen Deep Clean',
            description: 'Complete kitchen cleaning',
            price: 399,
          ),
          ServicePackage(
            name: 'Bathroom Deep Clean',
            description: 'Complete bathroom sanitization',
            price: 299,
          ),
          ServicePackage(
            name: 'Full Home Deep Clean',
            description: 'Entire home deep cleaning',
            price: 799,
          ),
        ],
        rating: 4.7,
        totalReviews: 920,
      ),

      ServiceModel(
        id: 'carpet_cleaning',
        name: 'Carpet Cleaning',
        icon: '🪑',
        description: 'Professional carpet and upholstery cleaning',
        imageUrl: 'https://picsum.photos/300/200?random=11',
        price: 99,
        category: 'Cleaning',
        duration: 90,
        packages: [
          ServicePackage(
            name: 'Single Carpet',
            description: 'One carpet/rug cleaning',
            price: 99,
          ),
          ServicePackage(
            name: 'Sofa Cleaning',
            description: '3-seater sofa cleaning',
            price: 199,
          ),
          ServicePackage(
            name: 'Complete Set',
            description: 'All carpets and furniture',
            price: 499,
          ),
        ],
        rating: 4.4,
        totalReviews: 560,
      ),

      ServiceModel(
        id: 'pest_control',
        name: 'Pest Control',
        icon: '🐛',
        description: 'Professional pest control services',
        imageUrl: 'https://picsum.photos/300/200?random=12',
        price: 299,
        category: 'Home Care',
        duration: 120,
        packages: [
          ServicePackage(
            name: 'Basic Treatment',
            description: 'Single room pest control',
            price: 299,
          ),
          ServicePackage(
            name: 'Full Home Treatment',
            description: 'Complete home pest control',
            price: 599,
          ),
          ServicePackage(
            name: 'Annual Package',
            description: '4 treatments with warranty',
            price: 1999,
          ),
        ],
        rating: 4.3,
        totalReviews: 430,
      ),
    ];
  }

  static List<ServiceModel> getServicesByCategory(String category) {
    return getAllServices()
        .where((service) => service.category == category)
        .toList();
  }

  static List<ServiceModel> searchServices(String query) {
    final lowercaseQuery = query.toLowerCase();
    return getAllServices().where((service) {
      return service.name.toLowerCase().contains(lowercaseQuery) ||
          service.description.toLowerCase().contains(lowercaseQuery) ||
          service.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  static List<String> getCategories() {
    final categories =
        getAllServices().map((service) => service.category).toSet().toList();
    categories.sort();
    return categories;
  }

  static ServiceModel? getServiceById(String id) {
    try {
      return getAllServices().firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }
}
