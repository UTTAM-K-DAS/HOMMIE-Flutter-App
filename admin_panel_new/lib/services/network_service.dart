import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = true;

  // Getters
  bool get isConnected => _isConnected;

  // Initialize network monitoring
  void initialize() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
    _checkInitialConnection();
  }

  // Check initial connection status
  Future<void> _checkInitialConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      _isConnected = false;
    }
  }

  // Update connection status
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected = results.any((result) => 
      result == ConnectivityResult.mobile || 
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet
    );

    // Notify about connection changes
    if (wasConnected != _isConnected) {
      _notifyConnectionChange();
    }
  }

  // Notify about connection changes
  void _notifyConnectionChange() {
    // You can implement additional logic here like showing snackbars
    debugPrint('Network status changed: ${_isConnected ? 'Connected' : 'Disconnected'}');
  }

  // Generic HTTP GET request with error handling
  Future<Map<String, dynamic>?> get(String url, {Map<String, String>? headers}) async {
    if (!_isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  // Generic HTTP POST request with error handling
  Future<Map<String, dynamic>?> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    if (!_isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: body != null ? json.encode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  // Generic HTTP PUT request with error handling
  Future<Map<String, dynamic>?> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    if (!_isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: body != null ? json.encode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  // Generic HTTP DELETE request with error handling
  Future<Map<String, dynamic>?> delete(String url, {Map<String, String>? headers}) async {
    if (!_isConnected) {
      throw NetworkException('No internet connection');
    }

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  // Handle HTTP response
  Map<String, dynamic>? _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        }
        return null;
      case 400:
        throw NetworkException('Bad request: ${response.body}');
      case 401:
        throw NetworkException('Unauthorized access');
      case 403:
        throw NetworkException('Forbidden access');
      case 404:
        throw NetworkException('Resource not found');
      case 500:
        throw NetworkException('Internal server error');
      default:
        throw NetworkException('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // Check if specific URL is reachable
  Future<bool> isUrlReachable(String url) async {
    try {
      final response = await http.head(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

// Custom exception for network errors
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

// Network status widget
class NetworkStatusWidget extends StatefulWidget {
  final Widget child;
  
  const NetworkStatusWidget({super.key, required this.child});

  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        setState(() {
          _isConnected = results.any((result) => 
            result == ConnectivityResult.mobile || 
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet
          );
        });
        
        if (!_isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white),
                  SizedBox(width: 8),
                  Text('No internet connection'),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_isConnected)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Colors.red,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'No internet connection',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}
