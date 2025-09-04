class ServicePackage {
  final String name;
  final String description;
  final double price;

  ServicePackage({
    required this.name,
    required this.description,
    required this.price,
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
      };
}

class Service {
  final String id;
  final String name;
  final String icon;
  final String description;
  final String imageUrl;
  final double startingPrice;
  final String category;
  final List<String> inclusions;
  final List<ServicePackage> packages;

  Service({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.imageUrl,
    required this.startingPrice,
    required this.category,
    required this.inclusions,
    required this.packages,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      startingPrice: (json['startingPrice'] as num).toDouble(),
      category: json['category'] as String,
      inclusions: List<String>.from(json['inclusions'] as List),
      packages: (json['packages'] as List)
          .map((e) => ServicePackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'description': description,
        'imageUrl': imageUrl,
        'startingPrice': startingPrice,
        'category': category,
        'inclusions': inclusions,
        'packages': packages.map((e) => e.toJson()).toList(),
      };
}
