import 'package:cloud_firestore/cloud_firestore.dart';
import 'unified_service_model.dart';

class BookingModel {
  final String id;
  final String userId;
  final ServiceModel service;
  final DateTime dateTime;
  final String status;
  final String? notes;
  final double totalAmount;
  final Map<String, dynamic>? extras;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? rating;
  final String? review;
  final String? address;

  BookingModel({
    required this.id,
    required this.userId,
    required this.service,
    required this.dateTime,
    required this.status,
    this.notes,
    required this.totalAmount,
    this.extras,
    required this.createdAt,
    this.updatedAt,
    this.rating,
    this.review,
    this.address,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      userId: map['userId'] ?? '',
      service: ServiceModel.fromMap(
        map['service'] ?? {},
        map['serviceId'] ?? '',
      ),
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      notes: map['notes'],
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      extras: map['extras'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      rating: (map['rating'] as num?)?.toDouble(),
      review: map['review'] as String?,
      address: map['address'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'serviceId': service.id,
      'service': service.toMap(),
      'dateTime': Timestamp.fromDate(dateTime),
      'status': status,
      'notes': notes,
      'totalAmount': totalAmount,
      'extras': extras,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'rating': rating,
      'review': review,
      'address': address,
    };
  }

  BookingModel copyWith({
    String? id,
    String? userId,
    ServiceModel? service,
    DateTime? dateTime,
    String? status,
    String? notes,
    double? totalAmount,
    Map<String, dynamic>? extras,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    String? review,
    String? address,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      service: service ?? this.service,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      totalAmount: totalAmount ?? this.totalAmount,
      extras: extras ?? this.extras,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      address: address ?? this.address,
    );
  }
}
