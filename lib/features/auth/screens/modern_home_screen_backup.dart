import 'package:flutter/material.dart';
import '../../profile/screens/profile_screen.dart';
import '../../booking/screens/bookings_screen.dart';

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({Key? key}) : super(key: key);

  @override
  _ModernHomeScreenState createState() => _ModernHomeScreenState();
}

// Simple Home Screen without overflow issues
class RichHomeScreen extends StatelessWidget {
  const RichHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section - matches HTML prototype exactly
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Personal Assistant',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'One-stop solution for your services. Order any service, anytime.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            Navigator.pushNamed(context, '/search');
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Find your service here e.g. AC, Car, Facial...',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child: Icon(Icons.search, color: Colors.grey),
                            ),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFff6b35),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Recommended Services Section
                    _buildSectionHeader('Recommended', () {
                      Navigator.pushNamed(context, '/view-all', arguments: {
                        'category': 'recommended',
                        'title': 'Recommended'
                      });
                    }),
                    const SizedBox(height: 15),
                    _buildHorizontalServiceList([
                      ServiceItem('❄️', 'AC Servicing', 'From ৳299'),
                      ServiceItem('🧹', 'Home Cleaning', 'From ৳199'),
                      ServiceItem('💅', 'Salon Care', 'From ৳149'),
                      ServiceItem('🚗', 'Driver', 'From ৳12/km'),
                    ]),

                    const SizedBox(height: 30),

                    // For Your Home Section
                    _buildSectionHeader('For Your Home', () {
                      Navigator.pushNamed(context, '/view-all', arguments: {
                        'category': 'home',
                        'title': 'For Your Home'
                      });
                    }),
                    const SizedBox(height: 15),
                    _buildServiceGrid([
                      ServiceItem('🔧', 'Plumbing & Sanitary', 'From ৳199'),
                      ServiceItem('📦', 'House Shifting', 'From ৳1,999'),
                      ServiceItem('🧽', 'Home Cleaning', 'From ৳199'),
                      ServiceItem('🎨', 'Painting Services', 'From ৳8/sq ft'),
                    ]),

                    const SizedBox(height: 30),

                    // Trending Services Section
                    _buildSectionHeader('Trending', () {
                      Navigator.pushNamed(context, '/view-all', arguments: {
                        'category': 'trending',
                        'title': 'Trending'
                      });
                    }),
                    const SizedBox(height: 15),
                    _buildHorizontalServiceList([
                      ServiceItem('❄️', 'AC Servicing', 'From ৳299'),
                      ServiceItem('🧹', 'Home Cleaning', 'From ৳199'),
                      ServiceItem('🪑', 'Furniture Cleaning', 'From ৳99'),
                      ServiceItem('🏠', 'House Shifting', 'From ৳1,999'),
                    ]),

                    const SizedBox(height: 30),

                    // Why Choose Us Stats Section - matches HTML exactly
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFff6b35), Color(0xFFf7931e)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          const Text(
                            'Why Choose Us',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Because we care about your safety',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildStatItem(
                                      '15,000+', 'Service Providers')),
                              Expanded(
                                  child: _buildStatItem(
                                      '2,00,000+', 'Orders Served')),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: _buildStatItem(
                                      '1,00,000+', '5 Star Reviews')),
                              Expanded(
                                  child: _buildStatItem('24/7', 'Support')),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80), // Extra bottom padding
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF667eea),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceGrid(List<ServiceItem> services) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.2, // Wider aspect ratio to prevent overflow
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildSimpleServiceCard(service);
      },
    );
  }

  Widget _buildHorizontalServiceList(List<ServiceItem> services) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 15),
            child: _buildRecommendationCard(service),
          );
        },
      ),
    );
  }

  Widget _buildSimpleServiceCard(ServiceItem service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // Navigator.pushNamed(context, '/service', arguments: service);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  service.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  service.price,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667eea),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(ServiceItem service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // Navigator.pushNamed(context, '/service', arguments: service);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      service.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  service.price,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF667eea),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ServiceItem {
  final String icon;
  final String name;
  final String price;

  ServiceItem(this.icon, this.name, this.price);
}

class _ModernHomeScreenState extends State<ModernHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RichHomeScreen(), // Using new rich home screen
    const BookingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF667eea),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
