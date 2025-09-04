import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;
  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.blueGrey[900],
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.admin_panel_settings, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'HOMMIE Admin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          _buildNavItem(Icons.dashboard, 'Dashboard', 0),
          _buildNavItem(Icons.engineering, 'Providers', 1),
          _buildNavItem(Icons.cleaning_services, 'Services', 2),
          _buildNavItem(Icons.calendar_today, 'Bookings', 3),
          _buildNavItem(Icons.people, 'Users', 4),
          const Spacer(),
          _buildNavItem(Icons.logout, 'Logout', 5),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onSelect(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueGrey[700] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: index == 5 ? Colors.red[300] : Colors.white),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: index == 5 ? Colors.red[300] : Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
