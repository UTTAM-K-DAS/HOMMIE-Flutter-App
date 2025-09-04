import 'package:cloud_firestore/cloud_firestore.dart';

class SampleProviderData {
  static Future<void> addSampleProviders() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    final sampleProviders = [
      {
        'name': 'Ahmed Hassan',
        'imageUrl': '',
        'rating': 4.8,
        'experience': 5,
        'category': 'Cleaning',
        'pricePerHour': 150.0,
        'isAvailable': true,
        'services': ['Deep Cleaning', 'Regular Cleaning', 'Office Cleaning'],
        'description': 'Professional cleaning service with 5+ years experience',
        'contactInfo': {
          'phone': '+8801234567890',
          'email': 'ahmed.hassan@example.com',
        },
        'location': const GeoPoint(23.7808, 90.2792), // Dhaka coordinates
        'reviews': [
          {
            'userId': 'user1',
            'rating': 5,
            'comment': 'Excellent cleaning service!',
            'date': Timestamp.now(),
          },
          {
            'userId': 'user2',
            'rating': 4,
            'comment': 'Very professional and punctual',
            'date': Timestamp.now(),
          },
        ],
      },
      {
        'name': 'Fatima Rahman',
        'imageUrl': '',
        'rating': 4.9,
        'experience': 8,
        'category': 'Beauty & Wellness',
        'pricePerHour': 300.0,
        'isAvailable': true,
        'services': ['Facial', 'Hair Styling', 'Makeup'],
        'description': 'Certified beauty specialist with 8+ years experience',
        'contactInfo': {
          'phone': '+8801234567891',
          'email': 'fatima.rahman@example.com',
        },
        'location': const GeoPoint(23.7608, 90.3692),
        'reviews': [
          {
            'userId': 'user3',
            'rating': 5,
            'comment': 'Amazing makeup skills!',
            'date': Timestamp.now(),
          },
        ],
      },
      {
        'name': 'Mohammad Ali',
        'imageUrl': '',
        'rating': 4.6,
        'experience': 10,
        'category': 'Appliance Repair',
        'pricePerHour': 200.0,
        'isAvailable': true,
        'services': [
          'AC Repair',
          'Refrigerator Repair',
          'Washing Machine Repair'
        ],
        'description': 'Expert appliance technician with 10+ years experience',
        'contactInfo': {
          'phone': '+8801234567892',
          'email': 'mohammad.ali@example.com',
        },
        'location': const GeoPoint(23.7908, 90.4092),
        'reviews': [
          {
            'userId': 'user4',
            'rating': 5,
            'comment': 'Fixed my AC perfectly!',
            'date': Timestamp.now(),
          },
          {
            'userId': 'user5',
            'rating': 4,
            'comment': 'Quick and reliable service',
            'date': Timestamp.now(),
          },
        ],
      },
      {
        'name': 'Nasir Ahmed',
        'imageUrl': '',
        'rating': 4.7,
        'experience': 6,
        'category': 'Plumbing',
        'pricePerHour': 180.0,
        'isAvailable': true,
        'services': ['Pipe Repair', 'Drain Cleaning', 'Installation'],
        'description': 'Licensed plumber with 6+ years experience',
        'contactInfo': {
          'phone': '+8801234567893',
          'email': 'nasir.ahmed@example.com',
        },
        'location': const GeoPoint(23.8008, 90.3492),
        'reviews': [
          {
            'userId': 'user6',
            'rating': 5,
            'comment': 'Solved the problem quickly!',
            'date': Timestamp.now(),
          },
        ],
      },
      {
        'name': 'Rashida Begum',
        'imageUrl': '',
        'rating': 4.9,
        'experience': 7,
        'category': 'Cooking',
        'pricePerHour': 120.0,
        'isAvailable': true,
        'services': ['Home Cooking', 'Party Catering', 'Traditional Dishes'],
        'description':
            'Professional cook specializing in traditional Bengali cuisine',
        'contactInfo': {
          'phone': '+8801234567894',
          'email': 'rashida.begum@example.com',
        },
        'location': const GeoPoint(23.7508, 90.3892),
        'reviews': [
          {
            'userId': 'user7',
            'rating': 5,
            'comment': 'Delicious food, authentic taste!',
            'date': Timestamp.now(),
          },
          {
            'userId': 'user8',
            'rating': 5,
            'comment': 'Best home-cooked meals',
            'date': Timestamp.now(),
          },
        ],
      },
    ];

    try {
      for (var provider in sampleProviders) {
        await db.collection('serviceProviders').add(provider);
      }
      print('Sample providers added successfully!');
    } catch (e) {
      print('Error adding sample providers: $e');
    }
  }
}
