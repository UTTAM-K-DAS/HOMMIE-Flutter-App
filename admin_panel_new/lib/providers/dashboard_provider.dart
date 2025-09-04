import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Dashboard statistics
  int _totalUsers = 0;
  int _totalProviders = 0;
  int _totalServices = 0;
  int _totalBookings = 0;
  double _totalRevenue = 0.0;

  // Getters
  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalUsers => _totalUsers;
  int get totalProviders => _totalProviders;
  int get totalServices => _totalServices;
  int get totalBookings => _totalBookings;
  double get totalRevenue => _totalRevenue;

  // Set selected navigation index
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Load dashboard data
  Future<void> loadDashboardData() async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate loading data
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with real data from services
      _totalUsers = 1250;
      _totalProviders = 180;
      _totalServices = 45;
      _totalBookings = 3420;
      _totalRevenue = 125800.50;

      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      _setError('Failed to load dashboard data');
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  // Update statistics
  void updateStatistics({
    int? users,
    int? providers,
    int? services,
    int? bookings,
    double? revenue,
  }) {
    if (users != null) _totalUsers = users;
    if (providers != null) _totalProviders = providers;
    if (services != null) _totalServices = services;
    if (bookings != null) _totalBookings = bookings;
    if (revenue != null) _totalRevenue = revenue;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
