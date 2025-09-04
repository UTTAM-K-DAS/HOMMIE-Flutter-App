class ServiceCategory {
  final String id;
  final String name;
  final String icon;
  final String description;
  final List<Service> services;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.services,
  });
}

class Service {
  final String id;
  final String name;
  final String icon;
  final double basePrice;
  final String currency;
  final List<ServicePackage> packages;

  Service({
    required this.id,
    required this.name,
    required this.icon,
    required this.basePrice,
    this.currency = 'TK ',
    required this.packages,
  });

  String get formattedBasePrice => '$currency${basePrice.toStringAsFixed(0)}';
}

class ServicePackage {
  final String name;
  final String description;
  final double price;
  final String currency;

  ServicePackage({
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'TK ',
  });

  String get formattedPrice => '$currency${price.toStringAsFixed(0)}';
}
