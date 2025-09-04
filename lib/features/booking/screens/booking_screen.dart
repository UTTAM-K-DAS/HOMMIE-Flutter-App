import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/unified_service_model.dart';

import '../providers/booking_provider.dart';
import '../../../models/provider_model.dart';
import '../../../services/provider_service.dart';

class BookingScreen extends StatefulWidget {
  final ServiceModel service;
  final ServicePackage? selectedPackage;
  final String? providerId;
  final String? providerName;

  const BookingScreen({
    Key? key,
    required this.service,
    this.selectedPackage,
    this.providerId,
    this.providerName,
  }) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '9:00 AM';
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<String> _availableTimes = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  ProviderModel? _selectedProvider;

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.service.name}'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Service Package'),
          _buildPackageCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Select Service Provider'),
          _buildProviderList(),
          const SizedBox(height: 24),
          _buildSectionTitle('Select Date'),
          _buildDatePicker(),
          const SizedBox(height: 24),
          _buildSectionTitle('Select Time Slot'),
          _buildTimePicker(),
          const SizedBox(height: 24),
          _buildSectionTitle('Service Address'),
          _buildAddressField(),
          const SizedBox(height: 24),
          _buildSectionTitle('Additional Notes'),
          _buildNotesField(),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProviderList() {
    return SizedBox(
      height: 140,
      child: StreamBuilder<List<ProviderModel>>(
        stream: ProviderService.getAllActiveProviders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading providers: ${snapshot.error}'));
          }
          final providers = snapshot.data ?? [];
          if (providers.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('No providers available'),
                SizedBox(height: 4),
                Text(
                  'Please check admin panel to add providers',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              final isSelected = _selectedProvider?.id == provider.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedProvider = provider;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(12),
                  width: 200,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context)
                            .primaryColor
                            .withAlpha((0.1 * 255).toInt())
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(provider.photoUrl ??
                                'https://via.placeholder.com/100x100/607D8B/FFFFFF?text=User'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              provider.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(provider.rating.toStringAsFixed(1) ?? '4.5'),
                          const SizedBox(width: 8),
                          Text('${provider.completedJobs ?? 0} jobs'),
                        ],
                      ),
                      if (provider.price != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('৳${provider.price}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPackageCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(15),
            title: Text(
              widget.service.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.service.description),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.service.packages.length,
            itemBuilder: (context, index) {
              final package = widget.service.packages[index];
              return ListTile(
                title: Text(package.name),
                subtitle: Text(package.description),
                trailing: Text(
                  '৳${package.price}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = _selectedDate.day == date.day;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 70,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayName(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  Widget _buildTimePicker() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availableTimes.length,
        itemBuilder: (context, index) {
          final time = _availableTimes[index];
          final isSelected = _selectedTime == time;

          return GestureDetector(
            onTap: () => setState(() => _selectedTime = time),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressField() {
    return TextField(
      controller: _addressController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Enter your service address',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Any special instructions for the service provider?',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final totalAmount = _selectedProvider?.price ??
        (widget.service.packages.isNotEmpty
            ? widget.service.packages.first.price
            : 0);
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                '৳$totalAmount',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(': '),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processBooking() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final userProvider = context.read<UserProvider>();
      if (!userProvider.isAuthenticated) {
        Navigator.of(context).pop(); // Remove loading
        Navigator.pushNamed(context, '/login');
        return;
      }

      final userId = userProvider.userId;
      if (userId == null) {
        throw Exception('User ID not found');
      }

      if (_selectedProvider == null) {
        throw Exception('Please select a service provider');
      }

      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        int.parse(_selectedTime.split(':')[0]),
        0, // minutes
      );

      final bookingId = await context.read<BookingProvider>().createBooking(
        userId: userId,
        serviceId: widget.service.id,
        service: widget.service,
        dateTime: dateTime,
        totalAmount: (_selectedProvider!.price ??
                (widget.service.packages.isNotEmpty
                    ? widget.service.packages.first.price
                    : 0))
            .toDouble(),
        notes: _notesController.text,
        extras: {
          'providerId': _selectedProvider!.id,
          'providerName': _selectedProvider!.name,
          'providerPrice': _selectedProvider!.price,
        },
      );

      // Remove loading indicator and confirmation dialog
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      // Navigate to booking confirmation screen
      Navigator.pushNamed(
        context,
        '/confirmation',
        arguments: {'bookingId': bookingId},
      );
    } catch (e) {
      // Remove loading indicator
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create booking: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmBooking() {
    // Validate required fields
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your service address')),
      );
      return;
    }
    if (_selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a service provider')),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Confirm Booking'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfirmationDetail('Service', widget.service.name),
            _buildConfirmationDetail('Provider', _selectedProvider!.name),
            _buildConfirmationDetail(
                'Date', _selectedDate.toString().split(' ')[0]),
            _buildConfirmationDetail('Time', _selectedTime),
            _buildConfirmationDetail('Duration', '60 minutes'),
            _buildConfirmationDetail('Amount',
                '৳${_selectedProvider?.price ?? (widget.service.packages.isNotEmpty ? widget.service.packages.first.price : 0)}'),
            _buildConfirmationDetail('Address', _addressController.text),
            if (_notesController.text.isNotEmpty)
              _buildConfirmationDetail('Notes', _notesController.text),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Edit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
