import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCategoryModel {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String iconUrl;
  final String imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final List<ServiceSubType> subTypes;

  ServiceCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.iconUrl,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.subTypes,
  });

  factory ServiceCategoryModel.fromMap(Map<String, dynamic> data, String id) {
    return ServiceCategoryModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      iconName: data['iconName'] ?? 'home_repair_service',
      iconUrl: data['iconUrl'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      subTypes: (data['subTypes'] as List<dynamic>? ?? [])
          .map((item) => ServiceSubType.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'iconName': iconName,
      'iconUrl': iconUrl,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'subTypes': subTypes.map((subType) => subType.toMap()).toList(),
    };
  }
}

class ServiceSubType {
  final String name;
  final String description;
  final double basePrice;
  final int estimatedDuration; // in minutes
  final List<String> features;

  ServiceSubType({
    required this.name,
    required this.description,
    required this.basePrice,
    required this.estimatedDuration,
    required this.features,
  });

  factory ServiceSubType.fromMap(Map<String, dynamic> data) {
    return ServiceSubType(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      basePrice: (data['basePrice'] ?? 0.0).toDouble(),
      estimatedDuration: data['estimatedDuration'] ?? 60,
      features: List<String>.from(data['features'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'estimatedDuration': estimatedDuration,
      'features': features,
    };
  }
}
