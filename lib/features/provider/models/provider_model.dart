import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int experience;
  final String category;
  final double pricePerHour;
  final bool isAvailable;
  final List<String> services;
  final String description;
  final Map<String, dynamic> contactInfo;
  final GeoPoint location;
  final List<Map<String, dynamic>> reviews;

  ProviderModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.experience,
    required this.category,
    required this.pricePerHour,
    required this.isAvailable,
    required this.services,
    required this.description,
    required this.contactInfo,
    required this.location,
    required this.reviews,
  });

  factory ProviderModel.fromMap(Map<String, dynamic> data, String id) {
    return ProviderModel(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      experience: data['experience'] ?? 0,
      category: data['category'] ?? '',
      pricePerHour: (data['pricePerHour'] ?? 0.0).toDouble(),
      isAvailable: data['isAvailable'] ?? false,
      services: List<String>.from(data['services'] ?? []),
      description: data['description'] ?? '',
      contactInfo: Map<String, dynamic>.from(data['contactInfo'] ?? {}),
      location: data['location'] ?? const GeoPoint(0, 0),
      reviews: List<Map<String, dynamic>>.from(data['reviews'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'experience': experience,
      'category': category,
      'pricePerHour': pricePerHour,
      'isAvailable': isAvailable,
      'services': services,
      'description': description,
      'contactInfo': contactInfo,
      'location': location,
      'reviews': reviews,
    };
  }
}
