class ServicePackage {
  final String name;
  final String description;
  final double price;

  ServicePackage({
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
