class ServiceProvider {
  final String id;
  final String name;
  final double rating;
  final int reviewCount;
  final int experience;
  final double distance;
  final double basePrice;
  final String speciality;
  final String workingHours;
  final String responseTime;
  final List<ServiceOffered> services;
  final List<Review> reviews;
  final List<WorkPhoto> gallery;
  final String avatar;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    required this.distance,
    required this.basePrice,
    required this.speciality,
    required this.workingHours,
    required this.responseTime,
    required this.services,
    required this.reviews,
    required this.gallery,
    required this.avatar,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      experience: json['experience'] as int,
      distance: (json['distance'] as num).toDouble(),
      basePrice: (json['basePrice'] as num).toDouble(),
      speciality: json['speciality'] as String,
      workingHours: json['workingHours'] as String,
      responseTime: json['responseTime'] as String,
      services: (json['services'] as List)
          .map((e) => ServiceOffered.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      gallery: (json['gallery'] as List)
          .map((e) => WorkPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      avatar: json['avatar'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rating': rating,
        'reviewCount': reviewCount,
        'experience': experience,
        'distance': distance,
        'basePrice': basePrice,
        'speciality': speciality,
        'workingHours': workingHours,
        'responseTime': responseTime,
        'services': services.map((e) => e.toJson()).toList(),
        'reviews': reviews.map((e) => e.toJson()).toList(),
        'gallery': gallery.map((e) => e.toJson()).toList(),
        'avatar': avatar,
      };
}

class ServiceOffered {
  final String name;
  final double price;

  ServiceOffered({
    required this.name,
    required this.price,
  });

  factory ServiceOffered.fromJson(Map<String, dynamic> json) {
    return ServiceOffered(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
      };
}

class Review {
  final String customerName;
  final int rating;
  final String date;
  final String comment;

  Review({
    required this.customerName,
    required this.rating,
    required this.date,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      customerName: json['customerName'] as String,
      rating: json['rating'] as int,
      date: json['date'] as String,
      comment: json['comment'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'customerName': customerName,
        'rating': rating,
        'date': date,
        'comment': comment,
      };
}

class WorkPhoto {
  final String title;
  final String? url;

  WorkPhoto({
    required this.title,
    this.url,
  });

  factory WorkPhoto.fromJson(Map<String, dynamic> json) {
    return WorkPhoto(
      title: json['title'] as String,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
      };
}
