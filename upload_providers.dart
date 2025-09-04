// Dart script to batch upload providers to Firestore
// Run this with `dart run` after adding your Firebase config

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  await Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  final providers = [
    {
      'name': 'John Doe',
      'photoUrl': 'https://example.com/photo.jpg',
      'rating': 4.8,
      'completedJobs': 25,
      'price': 500,
      'services': ['cleaning', 'plumbing']
    },
    {
      'name': 'Jane Smith',
      'photoUrl': 'https://example.com/photo2.jpg',
      'rating': 4.6,
      'completedJobs': 18,
      'price': 600,
      'services': ['electrical', 'painting']
    },
    // Add more providers as needed
  ];

  for (final provider in providers) {
    await firestore.collection('providers').add(provider);
    print('Added provider: ${provider['name']}');
  }

  print('All providers uploaded!');
}
