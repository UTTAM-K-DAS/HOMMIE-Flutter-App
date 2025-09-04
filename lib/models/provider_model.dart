import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int completedJobs;
  final double pricePerHour;
  final bool isAvailable;
  final List<String> services;
  final DateTime createdAt;

  // Legacy fields for backward compatibility
  final String? photoUrl;
  final int? price;

  ProviderModel({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
    this.description = '',
    this.category = 'general',
    this.imageUrl = '',
    this.rating = 4.5,
    this.completedJobs = 0,
    this.pricePerHour = 50.0,
    this.isAvailable = true,
    this.services = const [],
    DateTime? createdAt,
    this.photoUrl, // Legacy field
    this.price, // Legacy field
  }) : createdAt = createdAt ?? DateTime.now();

  factory ProviderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProviderModel(
      id: doc.id,
      name: data['displayName'] ?? data['name'] ?? 'Unknown Provider',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      description: data['description'] ?? 'Professional service provider',
      category: data['category'] ?? 'general',
      imageUrl: data['photoURL'] ?? data['imageUrl'] ?? data['avatar'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.5,
      completedJobs: data['completedJobs'] ?? 0,
      pricePerHour: (data['pricePerHour'] as num?)?.toDouble() ?? 50.0,
      isAvailable: data['isAvailable'] ?? true,
      services: List<String>.from(data['services'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // Legacy fields
      photoUrl: data['photoURL'] ?? data['imageUrl'] ?? data['avatar'],
      price: data['price'] ?? data['pricePerHour']?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': name,
      'email': email,
      'phone': phone,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'photoURL': imageUrl,
      'avatar': imageUrl,
      'rating': rating,
      'completedJobs': completedJobs,
      'pricePerHour': pricePerHour,
      'isAvailable': isAvailable,
      'services': services,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
      'role': 'provider',
      'isActive': true,
    };
  }
}
