class ServiceProvider {
  final String id;
  final String name;
  final String profileImageUrl;
  final String bio;
  final double rating;
  final int totalReviews;
  final int totalJobs;
  final List<String> serviceCategories;
  final List<String> skills;
  final double hourlyRate;
  final bool isAvailable;
  final String location;
  final DateTime joinDate;
  final List<Review> reviews;

  const ServiceProvider({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.bio,
    required this.rating,
    required this.totalReviews,
    required this.totalJobs,
    required this.serviceCategories,
    required this.skills,
    required this.hourlyRate,
    required this.isAvailable,
    required this.location,
    required this.joinDate,
    this.reviews = const [],
  });

  String get formattedRating => rating.toStringAsFixed(1);
  String get formattedHourlyRate => '৳${hourlyRate.toStringAsFixed(0)}/hr';
  String get experienceYears =>
      DateTime.now().difference(joinDate).inDays ~/ 365 > 0
          ? '${DateTime.now().difference(joinDate).inDays ~/ 365}+ years'
          : 'Less than 1 year';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalJobs': totalJobs,
      'serviceCategories': serviceCategories,
      'skills': skills,
      'hourlyRate': hourlyRate,
      'isAvailable': isAvailable,
      'location': location,
      'joinDate': joinDate.millisecondsSinceEpoch,
      'reviews': reviews.map((r) => r.toMap()).toList(),
    };
  }

  factory ServiceProvider.fromMap(Map<String, dynamic> map) {
    return ServiceProvider(
      id: map['id'] as String,
      name: map['name'] as String,
      profileImageUrl: map['profileImageUrl'] as String,
      bio: map['bio'] as String,
      rating: (map['rating'] as num).toDouble(),
      totalReviews: map['totalReviews'] as int,
      totalJobs: map['totalJobs'] as int,
      serviceCategories: List<String>.from(map['serviceCategories']),
      skills: List<String>.from(map['skills']),
      hourlyRate: (map['hourlyRate'] as num).toDouble(),
      isAvailable: map['isAvailable'] as bool,
      location: map['location'] as String,
      joinDate: DateTime.fromMillisecondsSinceEpoch(map['joinDate'] as int),
      reviews: (map['reviews'] as List)
          .map((r) => Review.fromMap(r as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Review {
  final String id;
  final String customerName;
  final String customerImageUrl;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String serviceType;

  const Review({
    required this.id,
    required this.customerName,
    required this.customerImageUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.serviceType,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerImageUrl': customerImageUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'serviceType': serviceType,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      customerName: map['customerName'] as String,
      customerImageUrl: map['customerImageUrl'] as String,
      rating: map['rating'] as int,
      comment: map['comment'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      serviceType: map['serviceType'] as String,
    );
  }
}
