import 'package:flutter/material.dart';

class ProviderInfoCard extends StatelessWidget {
  final String providerName;
  final String providerImage;
  final String rating;

  const ProviderInfoCard({
    Key? key,
    required this.providerName,
    required this.providerImage,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        // Implement provider info card
        );
  }
}
