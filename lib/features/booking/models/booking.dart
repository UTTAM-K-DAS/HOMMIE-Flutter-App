import 'package:HOMMIE/features/services/models/provider.dart';
import 'package:HOMMIE/features/services/models/service.dart';

enum BookingStatus {
  confirmed,
  assigned,
  onTheWay,
  inProgress,
  completed,
  cancelled
}

class Booking {
  final String id;
  final Service service;
  final ServiceProvider provider;
  final ServicePackage package;
  final DateTime date;
  final String time;
  final String address;
  final String contactNumber;
  final double totalAmount;
  final String paymentMethod;
  final BookingStatus status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.service,
    required this.provider,
    required this.package,
    required this.date,
    required this.time,
    required this.address,
    required this.contactNumber,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      service: Service.fromJson(json['service'] as Map<String, dynamic>),
      provider:
          ServiceProvider.fromJson(json['provider'] as Map<String, dynamic>),
      package: ServicePackage.fromJson(json['package'] as Map<String, dynamic>),
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      address: json['address'] as String,
      contactNumber: json['contactNumber'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'service': service.toJson(),
        'provider': provider.toJson(),
        'package': package.toJson(),
        'date': date.toIso8601String(),
        'time': time,
        'address': address,
        'contactNumber': contactNumber,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'status': status.toString().split('.').last,
        'createdAt': createdAt.toIso8601String(),
      };
}
