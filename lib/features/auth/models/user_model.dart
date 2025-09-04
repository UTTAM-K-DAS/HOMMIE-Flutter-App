import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoURL;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final DateTime? lastUpdated;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoURL,
    required this.isActive,
    this.createdAt,
    this.lastLogin,
    this.lastUpdated,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      photoURL: map['photoURL'],
      isActive: map['isActive'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate(),
      lastUpdated: (map['lastUpdated'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoURL': photoURL,
      'isActive': isActive,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'lastUpdated':
          lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? photoURL,
    bool? isActive,
    DateTime? lastLogin,
    DateTime? lastUpdated,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      photoURL: photoURL ?? this.photoURL,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
