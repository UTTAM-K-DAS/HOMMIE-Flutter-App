import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/unified_service_model.dart';
import '../features/provider/models/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../features/auth/screens/modern_home_screen.dart';

class DateTimeScreen extends StatefulWidget {
  final ServiceModel selectedService;
  final ProviderModel? selectedProvider;

  const DateTimeScreen({
    Key? key,
    required this.selectedService,
    this.selectedProvider,
  }) : super(key: key);

  @override
  _DateTimeScreenState createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  int _selectedDay = DateTime.now().day;
  int _selectedRepeat = 0;
  String _selectedHour = '13:30';
  List<int> _selectedExteraCleaning = [];

  late final ItemScrollController _scrollController;

  final List<dynamic> _days = List.generate(31, (index) {
    final now = DateTime.now();
    final day = now.add(Duration(days: index));
    return [day.day, _getDayName(day.weekday)];
  });

  static String _getDayName(int weekday) {
    switch (weekday) {
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

  final List<String> _hours = <String>[
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00',
    '03:30',
    '04:00',
    '04:30',
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30',
  ];

  final List<String> _repeat = [
    'No repeat',
    'Every day',
    'Every week',
    'Every month'
  ];

  final List<dynamic> _exteraCleaning = [
    ['Washing', 'https://img.icons8.com/office/2x/washing-machine.png', '10'],
    ['Fridge', 'https://img.icons8.com/cotton/2x/fridge.png', '8'],
    [
      'Oven',
      'https://img.icons8.com/external-becris-lineal-color-becris/2x/external-oven-kitchen-cooking-becris-lineal-color-becris.png',
      '8'
    ],
    [
      'Vehicle',
      'https://img.icons8.com/external-vitaliy-gorbachev-blue-vitaly-gorbachev/2x/external-bycicle-carnival-vitaliy-gorbachev-blue-vitaly-gorbachev.png',
      '20'
    ],
    [
      'Windows',
      'https://img.icons8.com/external-kiranshastry-lineal-color-kiranshastry/2x/external-window-interiors-kiranshastry-lineal-color-kiranshastry-1.png',
      '20'
    ],
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ItemScrollController();
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollController.scrollTo(
        index: 24,
        duration: Duration(seconds: 3),
        curve: Curves.easeInOut,
      );
    });
  }

  double _calculateTotalAmount() {
    double baseAmount = 50.0; // Default base cost
    if (widget.selectedProvider != null) {
      baseAmount = widget.selectedProvider!.pricePerHour;
    } else {
      baseAmount = widget.selectedService.price;
    }

    double extraAmount = 0.0;

    // Add costs for extra services
    for (int index in _selectedExteraCleaning) {
      extraAmount += double.parse(_exteraCleaning[index][2]);
    }

    // Apply repeat discount
    double repeatDiscount = 0.0;
    if (_selectedRepeat == 1) {
      // Every day
      repeatDiscount = 0.2; // 20% discount
    } else if (_selectedRepeat == 2) {
      // Every week
      repeatDiscount = 0.15; // 15% discount
    } else if (_selectedRepeat == 3) {
      // Every month
      repeatDiscount = 0.1; // 10% discount
    }

    double totalBeforeDiscount = baseAmount + extraAmount;
    double discountAmount = totalBeforeDiscount * repeatDiscount;
    return totalBeforeDiscount - discountAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please login to book a service')),
              );
              return;
            }

            final now = DateTime.now();
            final selectedDate = DateTime(now.year, now.month, _selectedDay);

            final booking = {
              'userId': user.uid,
              'serviceId': widget.selectedService.name.toLowerCase(),
              'serviceName': widget.selectedService.name,
              'providerId': widget.selectedProvider?.id,
              'providerName': widget.selectedProvider?.name,
              'bookingDate': selectedDate,
              'timeSlot': _selectedHour,
              'status': 'Pending',
              'createdAt': FieldValue.serverTimestamp(),
              'totalAmount': _calculateTotalAmount(),
              'extraServices': _selectedExteraCleaning
                  .map((index) => _exteraCleaning[index][0])
                  .toList(),
              'repeatType': _repeat[_selectedRepeat],
              'paymentStatus': 'Pending',
              'paymentMethod': 'COD',
              'userNote': '',
              'serviceDetails': {
                'name': widget.selectedService.name,
                'imageUrl': widget.selectedService.imageUrl,
              },
              'providerDetails': widget.selectedProvider != null
                  ? {
                      'id': widget.selectedProvider!.id,
                      'name': widget.selectedProvider!.name,
                      'imageUrl': widget.selectedProvider!.imageUrl,
                      'pricePerHour': widget.selectedProvider!.pricePerHour,
                      'rating': widget.selectedProvider!.rating,
                    }
                  : null,
            };

            final bookingRef = await FirebaseFirestore.instance
                .collection('bookings')
                .add(booking);

            // Add the booking reference to user's bookings collection
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('bookings')
                .doc(bookingRef.id)
                .set({
              'bookingId': bookingRef.id,
              'createdAt': FieldValue.serverTimestamp(),
            });

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking confirmed!')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ModernHomeScreen()),
              (route) => false,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.toString()}')),
            );
          }
        },
        child: Icon(Icons.arrow_forward_ios),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: FadeInUp(
                child: Padding(
                  padding: EdgeInsets.only(top: 120.0, right: 20.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedService.name,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.selectedProvider != null) ...[
                        SizedBox(height: 4),
                        Text(
                          'with ${widget.selectedProvider!.name}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      SizedBox(height: 8),
                      Text(
                        'Select Date & Time',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              FadeInUp(
                child: Row(
                  children: [
                    Text(
                      "${DateTime.now().year} - ${DateTime.now().month}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Today: ${DateTime.now().day}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(width: 1.5, color: Colors.grey.shade200),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FadeInUp(
                      delay: Duration(milliseconds: 100 * index),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = _days[index][0];
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 62,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _selectedDay == _days[index][0]
                                ? Colors.blue.shade100.withAlpha(5)
                                : Colors.blue.withAlpha(0),
                            border: Border.all(
                              color: _selectedDay == _days[index][0]
                                  ? Colors.blue
                                  : Colors.white.withAlpha(0),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _days[index][0].toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _days[index][1],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(width: 1.5, color: Colors.grey.shade200),
                  ),
                  child: ScrollablePositionedList.builder(
                    itemScrollController: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _hours.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedHour = _hours[index];
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _selectedHour == _hours[index]
                                ? Colors.orange.shade100.withAlpha(5)
                                : Colors.orange.withAlpha(0),
                            border: Border.all(
                              color: _selectedHour == _hours[index]
                                  ? Colors.orange
                                  : Colors.white.withAlpha(0),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _hours[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              FadeInUp(
                child: Text(
                  "Repeat",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _repeat.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRepeat = index;
                        });
                      },
                      child: FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: _selectedRepeat == index
                                ? Colors.blue.shade400
                                : Colors.grey.shade100,
                          ),
                          margin: EdgeInsets.only(right: 20),
                          child: Center(
                            child: Text(
                              _repeat[index],
                              style: TextStyle(
                                fontSize: 18,
                                color: _selectedRepeat == index
                                    ? Colors.white
                                    : Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 40),
              FadeInUp(
                child: Text(
                  "Additional Services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _exteraCleaning.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedExteraCleaning.contains(index)) {
                            _selectedExteraCleaning.remove(index);
                          } else {
                            _selectedExteraCleaning.add(index);
                          }
                        });
                      },
                      child: FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: Container(
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: _selectedExteraCleaning.contains(index)
                                ? Colors.blue.shade400
                                : Colors.transparent,
                          ),
                          margin: EdgeInsets.only(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                _exteraCleaning[index][1],
                                height: 40,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.broken_image, size: 40);
                                },
                              ),
                              SizedBox(height: 10),
                              Text(
                                _exteraCleaning[index][0],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _selectedExteraCleaning.contains(index)
                                      ? Colors.white
                                      : Colors.grey.shade800,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "+${_exteraCleaning[index][2]}\$",
                                style: TextStyle(
                                  color: _selectedExteraCleaning.contains(index)
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
