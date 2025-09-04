
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onSelectPage;

  Sidebar({required this.onSelectPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(child: Text('Admin Panel', style: TextStyle(color: Colors.white)), decoration: BoxDecoration(color: Colors.blueGrey)),
          ListTile(title: Text('Dashboard'), onTap: () => onSelectPage(0)),
          ListTile(title: Text('Bookings'), onTap: () => onSelectPage(1)),
          ListTile(title: Text('Services'), onTap: () => onSelectPage(2)),
          ListTile(title: Text('Users'), onTap: () => onSelectPage(3)),
        ],
      ),
    );
  }
}
