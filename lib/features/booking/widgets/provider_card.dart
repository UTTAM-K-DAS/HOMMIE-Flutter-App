import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  final String name;
  final String rating;
  final String price;
  final VoidCallback onSelect;

  const ProviderCard({
    Key? key,
    required this.name,
    required this.rating,
    required this.price,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(name[0]),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        title: Text(name),
        subtitle: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            Text(' $rating'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '৳$price',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        onTap: onSelect,
      ),
    );
  }
}
