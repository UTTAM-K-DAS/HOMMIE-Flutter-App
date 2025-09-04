import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class BookingStatusScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text('My Bookings')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getUserBookingsStream(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!;

          if (bookings.isEmpty) {
            return Center(child: Text('No Bookings Yet'));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              // Convert Firestore Timestamp to DateTime
              DateTime bookingDate;
              if (booking['bookingDate'] is Timestamp) {
                bookingDate = (booking['bookingDate'] as Timestamp).toDate();
              } else if (booking['bookingDate'] is DateTime) {
                bookingDate = booking['bookingDate'];
              } else {
                bookingDate = DateTime.now();
              }

              return Card(
                child: ListTile(
                  title: Text('Service ID: ${booking['serviceId']}'),
                  subtitle: Text('Status: ${booking['status']}'),
                  trailing: Text('${bookingDate.toLocal()}'.split(' ')[0]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
