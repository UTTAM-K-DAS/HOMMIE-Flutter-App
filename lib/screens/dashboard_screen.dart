import 'package:flutter/material.dart';
import '../features/services/screens/service_list_screen.dart';
import '../widgets/sidebar.dart';
import '../features/booking/screens/bookings_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedPage = 0;

  final List<Widget> pages = [
    Center(child: Text('Welcome to Admin Dashboard')),
    BookingsScreen(),
    ServiceListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel')),
      drawer: Sidebar(onSelectPage: (index) {
        setState(() => selectedPage = index);
        Navigator.pop(context);
      }),
      body: pages[selectedPage],
    );
  }
}
