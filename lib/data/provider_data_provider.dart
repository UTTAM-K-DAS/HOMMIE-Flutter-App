import '../data/models/service_provider_model.dart';

class ProviderDataProvider {
  static List<ServiceProvider> getAllProviders() {
    return [
      ServiceProvider(
        id: 'provider_1',
        name: 'Mohammad Rahman',
        profileImageUrl: 'https://picsum.photos/150/150?random=201',
        bio:
            'Experienced AC technician with 8+ years of expertise in servicing all brands of air conditioners.',
        rating: 4.8,
        totalReviews: 156,
        totalJobs: 280,
        serviceCategories: ['AC Service', 'Appliance'],
        skills: [
          'AC Installation',
          'AC Repair',
          'Gas Refilling',
          'Maintenance'
        ],
        hourlyRate: 300,
        isAvailable: true,
        location: 'Dhanmondi, Dhaka',
        joinDate: DateTime(2016, 3, 15),
        reviews: [
          Review(
            id: 'review_1',
            customerName: 'Sarah Ahmed',
            customerImageUrl:
                'https://via.placeholder.com/100x100/E3F2FD/1976D2?text=SA',
            rating: 5,
            comment:
                'Excellent service! Fixed my AC perfectly and explained everything clearly.',
            createdAt: DateTime.now().subtract(Duration(days: 2)),
            serviceType: 'AC Basic Service',
          ),
          Review(
            id: 'review_2',
            customerName: 'Karim Hassan',
            customerImageUrl:
                'https://via.placeholder.com/100x100/E8F5E8/2E7D32?text=KH',
            rating: 5,
            comment: 'Very professional and punctual. Highly recommend!',
            createdAt: DateTime.now().subtract(Duration(days: 5)),
            serviceType: 'AC Deep Service',
          ),
        ],
      ),
      ServiceProvider(
        id: 'provider_2',
        name: 'Fatema Khatun',
        profileImageUrl:
            'https://via.placeholder.com/150x150/E91E63/FFFFFF?text=FK',
        bio:
            'Professional house cleaning expert specializing in deep cleaning and regular maintenance.',
        rating: 4.9,
        totalReviews: 203,
        totalJobs: 345,
        serviceCategories: ['Cleaning', 'Home Care'],
        skills: [
          'Deep Cleaning',
          'Regular Cleaning',
          'Kitchen Cleaning',
          'Bathroom Cleaning'
        ],
        hourlyRate: 200,
        isAvailable: true,
        location: 'Gulshan, Dhaka',
        joinDate: DateTime(2017, 8, 20),
        reviews: [
          Review(
            id: 'review_3',
            customerName: 'Rihan Malik',
            customerImageUrl:
                'https://via.placeholder.com/100x100/FCE4EC/AD1457?text=RM',
            rating: 5,
            comment:
                'Amazing cleaning service! House looks brand new. Very thorough work.',
            createdAt: DateTime.now().subtract(Duration(days: 1)),
            serviceType: 'Deep Cleaning',
          ),
        ],
      ),
      ServiceProvider(
        id: 'provider_3',
        name: 'Abdul Karim',
        profileImageUrl:
            'https://via.placeholder.com/150x150/2196F3/FFFFFF?text=AK',
        bio:
            'Skilled plumber with expertise in all types of plumbing work including installations and repairs.',
        rating: 4.6,
        totalReviews: 89,
        totalJobs: 165,
        serviceCategories: ['Plumbing'],
        skills: [
          'Pipe Installation',
          'Leak Repair',
          'Faucet Installation',
          'Drainage'
        ],
        hourlyRate: 350,
        isAvailable: true,
        location: 'Uttara, Dhaka',
        joinDate: DateTime(2018, 11, 10),
        reviews: [
          Review(
            id: 'review_4',
            customerName: 'Nasir Ahmed',
            customerImageUrl:
                'https://via.placeholder.com/100x100/E3F2FD/0277BD?text=NA',
            rating: 4,
            comment:
                'Good work but took a bit longer than expected. Overall satisfied.',
            createdAt: DateTime.now().subtract(Duration(days: 3)),
            serviceType: 'Plumbing Repair',
          ),
        ],
      ),
      ServiceProvider(
        id: 'provider_4',
        name: 'Rashida Begum',
        profileImageUrl:
            'https://via.placeholder.com/150x150/FF9800/FFFFFF?text=RB',
        bio:
            'Certified electrician with 6+ years experience in home and office electrical work.',
        rating: 4.7,
        totalReviews: 134,
        totalJobs: 198,
        serviceCategories: ['Electrical'],
        skills: [
          'Wiring',
          'Switch Installation',
          'Fan Installation',
          'Light Fixture'
        ],
        hourlyRate: 280,
        isAvailable: false,
        location: 'Mirpur, Dhaka',
        joinDate: DateTime(2018, 5, 3),
        reviews: [
          Review(
            id: 'review_5',
            customerName: 'Tanvir Islam',
            customerImageUrl:
                'https://via.placeholder.com/100x100/FFF3E0/EF6C00?text=TI',
            rating: 5,
            comment:
                'Very knowledgeable and safety-conscious. Excellent electrical work.',
            createdAt: DateTime.now().subtract(Duration(days: 7)),
            serviceType: 'Electrical Service',
          ),
        ],
      ),
      ServiceProvider(
        id: 'provider_5',
        name: 'Shahidul Islam',
        profileImageUrl:
            'https://via.placeholder.com/150x150/9C27B0/FFFFFF?text=SI',
        bio:
            'Professional painter with artistic skills and experience in both residential and commercial painting.',
        rating: 4.5,
        totalReviews: 67,
        totalJobs: 89,
        serviceCategories: ['Painting'],
        skills: [
          'Wall Painting',
          'Ceiling Painting',
          'Exterior Painting',
          'Color Consultation'
        ],
        hourlyRate: 250,
        isAvailable: true,
        location: 'Wari, Dhaka',
        joinDate: DateTime(2019, 2, 18),
        reviews: [
          Review(
            id: 'review_6',
            customerName: 'Marium Sultana',
            customerImageUrl:
                'https://via.placeholder.com/100x100/F3E5F5/7B1FA2?text=MS',
            rating: 4,
            comment:
                'Nice painting work. Clean and professional. Happy with the result.',
            createdAt: DateTime.now().subtract(Duration(days: 4)),
            serviceType: 'Wall Painting',
          ),
        ],
      ),
      ServiceProvider(
        id: 'provider_6',
        name: 'Salma Khatun',
        profileImageUrl:
            'https://via.placeholder.com/150x150/E91E63/FFFFFF?text=SK',
        bio:
            'Beauty expert providing professional salon services at home with 5+ years experience.',
        rating: 4.9,
        totalReviews: 187,
        totalJobs: 234,
        serviceCategories: ['Beauty', 'Salon'],
        skills: [
          'Facial',
          'Hair Styling',
          'Manicure',
          'Pedicure',
          'Bridal Makeup'
        ],
        hourlyRate: 400,
        isAvailable: true,
        location: 'Banani, Dhaka',
        joinDate: DateTime(2019, 7, 12),
        reviews: [
          Review(
            id: 'review_7',
            customerName: 'Ayesha Rahman',
            customerImageUrl:
                'https://via.placeholder.com/100x100/FCE4EC/C2185B?text=AR',
            rating: 5,
            comment:
                'Absolutely fantastic! Professional service and amazing results. Will book again!',
            createdAt: DateTime.now().subtract(Duration(hours: 6)),
            serviceType: 'Bridal Package',
          ),
        ],
      ),
      ServiceProvider(
        id: 'provider_7',
        name: 'Rafiqul Islam',
        profileImageUrl:
            'https://via.placeholder.com/150x150/607D8B/FFFFFF?text=RI',
        bio:
            'Experienced driver with clean driving record and knowledge of Dhaka city routes.',
        rating: 4.4,
        totalReviews: 95,
        totalJobs: 156,
        serviceCategories: ['Transport', 'Driver'],
        skills: [
          'City Navigation',
          'Safe Driving',
          'Vehicle Maintenance',
          'Customer Service'
        ],
        hourlyRate: 150,
        isAvailable: true,
        location: 'Mohammadpur, Dhaka',
        joinDate: DateTime(2020, 1, 8),
        reviews: [
          Review(
            id: 'review_8',
            customerName: 'Imran Hossain',
            customerImageUrl:
                'https://via.placeholder.com/100x100/ECEFF1/455A64?text=IH',
            rating: 4,
            comment:
                'Good driver, knows the roads well. Safe and comfortable ride.',
            createdAt: DateTime.now().subtract(Duration(days: 1)),
            serviceType: 'Driver Service',
          ),
        ],
      ),
      ServiceProvider(
        id: 'provider_8',
        name: 'Rubina Akter',
        profileImageUrl:
            'https://via.placeholder.com/150x150/795548/FFFFFF?text=RA',
        bio:
            'House shifting specialist with team of trained workers and proper equipment.',
        rating: 4.3,
        totalReviews: 43,
        totalJobs: 67,
        serviceCategories: ['Shifting', 'Moving'],
        skills: [
          'Packing',
          'Loading',
          'Transportation',
          'Unpacking',
          'Furniture Assembly'
        ],
        hourlyRate: 500,
        isAvailable: true,
        location: 'Tejgaon, Dhaka',
        joinDate: DateTime(2021, 4, 25),
        reviews: [
          Review(
            id: 'review_9',
            customerName: 'Farid Ahmed',
            customerImageUrl:
                'https://via.placeholder.com/100x100/EFEBE9/5D4037?text=FA',
            rating: 4,
            comment: 'Handled our belongings carefully. Good service overall.',
            createdAt: DateTime.now().subtract(Duration(days: 8)),
            serviceType: '2 BHK Shifting',
          ),
        ],
      ),
    ];
  }

  static List<ServiceProvider> getProvidersByCategory(String category) {
    return getAllProviders()
        .where((provider) => provider.serviceCategories.contains(category))
        .toList();
  }

  static List<ServiceProvider> getAvailableProviders() {
    return getAllProviders().where((provider) => provider.isAvailable).toList();
  }

  static List<ServiceProvider> getTopRatedProviders({int limit = 5}) {
    final providers = getAllProviders();
    providers.sort((a, b) => b.rating.compareTo(a.rating));
    return providers.take(limit).toList();
  }

  static ServiceProvider? getProviderById(String id) {
    try {
      return getAllProviders().firstWhere((provider) => provider.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ServiceProvider> searchProviders(String query) {
    final lowercaseQuery = query.toLowerCase();
    return getAllProviders().where((provider) {
      return provider.name.toLowerCase().contains(lowercaseQuery) ||
          provider.bio.toLowerCase().contains(lowercaseQuery) ||
          provider.skills
              .any((skill) => skill.toLowerCase().contains(lowercaseQuery)) ||
          provider.serviceCategories.any(
              (category) => category.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }
}
