import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/unified_service_model.dart';

class BookingModel {
  final String id;
  final String userId;
  final ServiceModel service;
  final DateTime dateTime;
  final String status; // pending, confirmed, completed, cancelled
  final String? notes;
  final double totalAmount;
  final Map<String, dynamic>? extras;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? rating;
  final String? review;

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
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      userId: map['userId'] ?? '',
      service:
          ServiceModel.fromMap(map['service'] ?? {}, map['serviceId'] ?? ''),
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      notes: map['notes'],
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      extras: map['extras'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      rating: (map['rating'] as num?)?.toDouble(),
      review: map['review'] as String?,
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
    };
  }

  BookingModel copyWith({
    String? status,
    String? notes,
    double? totalAmount,
    Map<String, dynamic>? extras,
    DateTime? updatedAt,
    double? rating,
    String? review,
  }) {
    return BookingModel(
      id: id,
      userId: userId,
      service: service,
      dateTime: dateTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      totalAmount: totalAmount ?? this.totalAmount,
      extras: extras ?? this.extras,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }
}
