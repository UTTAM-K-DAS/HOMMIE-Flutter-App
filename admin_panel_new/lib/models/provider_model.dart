import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderModel {
  final String id;
  final String name;
  final String? photoUrl;
  final double? rating;
  final int? completedJobs;
  final int? price;
  final String? email;
  final String? phone;
  final String? address;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // New fields for enhanced provider management
  final String? description;
  final String? category;
  final double? pricePerHour;
  final List<String>? services;
  final bool? isActive;
  final bool? isAvailable;

  ProviderModel({
    required this.id,
    required this.name,
    this.photoUrl,
    this.rating,
    this.completedJobs,
    this.price,
    this.email,
    this.phone,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.category,
    this.pricePerHour,
    this.services,
    this.isActive,
    this.isAvailable,
  });

  factory ProviderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProviderModel(
      id: doc.id,
      name: data['displayName'] ?? data['name'] ?? '',
      photoUrl: data['photoURL'] ?? data['photoUrl'] ?? data['avatar'],
      rating: (data['rating'] != null)
          ? (data['rating'] as num).toDouble()
          : null,
      completedJobs: data['completedJobs'],
      price: data['price'],
      email: data['email'],
      phone: data['phone'],
      address: data['address'],
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      description: data['description'],
      category: data['category'],
      pricePerHour: (data['pricePerHour'] != null)
          ? (data['pricePerHour'] as num).toDouble()
          : null,
      services: data['services'] != null
          ? List<String>.from(data['services'])
          : null,
      isActive: data['isActive'],
      isAvailable: data['isAvailable'],
    );
  }

  factory ProviderModel.fromMap(Map<String, dynamic> data, String docId) {
    return ProviderModel(
      id: docId,
      name: data['displayName'] ?? data['name'] ?? '',
      photoUrl: data['photoURL'] ?? data['photoUrl'] ?? data['avatar'],
      rating: (data['rating'] != null)
          ? (data['rating'] as num).toDouble()
          : null,
      completedJobs: data['completedJobs'],
      price: data['price'],
      email: data['email'],
      phone: data['phone'],
      address: data['address'],
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
      description: data['description'],
      category: data['category'],
      pricePerHour: (data['pricePerHour'] != null)
          ? (data['pricePerHour'] as num).toDouble()
          : null,
      services: data['services'] != null
          ? List<String>.from(data['services'])
          : null,
      isActive: data['isActive'],
      isAvailable: data['isAvailable'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': name,
      'photoUrl': photoUrl,
      'photoURL': photoUrl,
      'avatar': photoUrl,
      'rating': rating ?? 4.5,
      'completedJobs': completedJobs ?? 0,
      'price': price,
      'pricePerHour': pricePerHour ?? 50.0,
      'email': email,
      'phone': phone,
      'address': address,
      'description': description,
      'category': category,
      'services': services ?? [],
      'status': status ?? 'approved',
      'isActive': isActive ?? true,
      'isAvailable': isAvailable ?? true,
      'role': 'provider', // Important for Firebase rules
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
