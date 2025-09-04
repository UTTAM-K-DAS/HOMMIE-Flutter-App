import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collectionGroup('bookings').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final bookings = snapshot.data!.docs;
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            var booking = bookings[index];
            return Card(
              child: ListTile(
                title: Text('Service ID: ${booking['serviceId']}'),
                subtitle: Text('Status: ${booking['status']}'),
                trailing: DropdownButton<String>(
                  value: booking['status'],
                  items: ['Pending', 'Accepted', 'In Progress', 'Completed']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      booking.reference.update({'status': newStatus});
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
