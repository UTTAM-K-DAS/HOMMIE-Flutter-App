import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;
  final String name;
  final String icon;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final int duration; // in minutes
  final bool isAvailable;
  final List<ServicePackage> packages;
  final double rating;
  final int totalReviews;
  final Map<String, dynamic>? extras;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.duration,
    this.isAvailable = true,
    this.packages = const [],
    this.rating = 4.5,
    this.totalReviews = 0,
    this.extras,
    this.createdAt,
    this.updatedAt,
  });

  // Convert price to BDT format
  String get formattedPrice => '৳${price.toStringAsFixed(0)}';

  // Format rating
  String get formattedRating => rating.toStringAsFixed(1);

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      name: data['name'] ?? '',
      icon: data['icon'] ?? '🛠️',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      duration: data['duration'] ?? 60,
      isAvailable: data['isAvailable'] ?? true,
      packages: List<ServicePackage>.from(
          data['packages']?.map((x) => ServicePackage.fromMap(x)) ?? []),
      rating: (data['rating'] ?? 4.5).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      extras: data['extras'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ServiceModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ServiceModel(
      id: documentId,
      name: data['name'] ?? '',
      icon: data['icon'] ?? '🛠️',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      duration: data['duration'] ?? 60,
      isAvailable: data['isAvailable'] ?? true,
      packages: List<ServicePackage>.from(
          data['packages']?.map((x) => ServicePackage.fromMap(x)) ?? []),
      rating: (data['rating'] ?? 4.5).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      extras: data['extras'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'category': category,
      'duration': duration,
      'isAvailable': isAvailable,
      'packages': packages.map((x) => x.toMap()).toList(),
      'rating': rating,
      'totalReviews': totalReviews,
      'extras': extras,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  ServiceModel copyWith({
    String? name,
    String? icon,
    String? description,
    String? imageUrl,
    double? price,
    String? category,
    int? duration,
    bool? isAvailable,
    List<ServicePackage>? packages,
    double? rating,
    int? totalReviews,
    Map<String, dynamic>? extras,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      isAvailable: isAvailable ?? this.isAvailable,
      packages: packages ?? this.packages,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      extras: extras ?? this.extras,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class ServicePackage {
  final String name;
  final String description;
  final double price;

  const ServicePackage({
    required this.name,
    required this.description,
    required this.price,
  });

  String get formattedPrice => '৳${price.toStringAsFixed(0)}';

  factory ServicePackage.fromMap(Map<String, dynamic> data) {
    return ServicePackage(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }
}
