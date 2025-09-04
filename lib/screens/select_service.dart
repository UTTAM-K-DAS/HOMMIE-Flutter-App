// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../models/unified_service_model.dart';
import 'provider_selection_screen.dart';

class SelectService extends StatefulWidget {
  final ServiceModel selectedService;

  const SelectService({Key? key, required this.selectedService})
      : super(key: key);

  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  List<ServiceModel> services = [
    ServiceModel(
      id: 'cleaning',
      name: 'Cleaning',
      icon: '🧹',
      description: 'Professional cleaning services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=6p58P6qa1K6x&format=png&color=000000',
      price: 50.0,
      category: 'Cleaning',
      duration: 120,
    ),
    ServiceModel(
      id: 'plumber',
      name: 'Plumber',
      icon: '🔧',
      description: 'Professional plumbing services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=vdKjvP5BmPT7&format=png&color=000000',
      price: 60.0,
      category: 'Maintenance',
      duration: 60,
    ),
    ServiceModel(
      id: 'electrician',
      name: 'Electrician',
      icon: '⚡',
      description: 'Professional electrical services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=l3ALH6RtWe6W&format=png&color=000000',
      price: 70.0,
      category: 'Maintenance',
      duration: 60,
    ),
    ServiceModel(
      id: 'painter',
      name: 'Painter',
      icon: '🎨',
      description: 'Professional painting services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=82122&format=png&color=000000',
      price: 55.0,
      category: 'Home Improvement',
      duration: 240,
    ),
    ServiceModel(
      id: 'carpenter',
      name: 'Carpenter',
      icon: '🔨',
      description: 'Professional carpentry services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=80825&format=png&color=000000',
      price: 65.0,
      category: 'Home Improvement',
      duration: 120,
    ),
    ServiceModel(
      id: 'gardener',
      name: 'Gardener',
      icon: '🌱',
      description: 'Professional gardening services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=wE0JO6Sj7Mfc&format=png&color=000000',
      price: 45.0,
      category: 'Outdoor',
      duration: 180,
    ),
    ServiceModel(
      id: 'tailor',
      name: 'Tailor',
      icon: '✂️',
      description: 'Professional tailoring services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=U3dYPIg1Hg80&format=png&color=000000',
      price: 40.0,
      category: 'Personal',
      duration: 120,
    ),
    ServiceModel(
      id: 'maid',
      name: 'Maid',
      icon: '🧽',
      description: 'Professional housekeeping services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=leN62JUQce0l&format=png&color=000000',
      price: 45.0,
      category: 'Cleaning',
      duration: 180,
    ),
    ServiceModel(
      id: 'driver',
      name: 'Driver',
      icon: '🚗',
      description: 'Professional driving services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=K8FhPy2wJQtK&format=png&color=000000',
      price: 35.0,
      category: 'Transportation',
      duration: 60,
    ),
    ServiceModel(
      id: 'cook',
      name: 'Cook',
      icon: '👨‍🍳',
      description: 'Professional cooking services',
      imageUrl:
          'https://img.icons8.com/?size=100&id=jmChQdAqiBUb&format=png&color=000000',
      price: 50.0,
      category: 'Personal',
      duration: 180,
    ),
  ];

  int selectedService = -1;

  @override
  void initState() {
    super.initState();
    selectedService = services.indexWhere(
      (s) => s.name == widget.selectedService.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: selectedService >= 0
          ? FloatingActionButton(
              onPressed: () {
                final service = services[selectedService];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProviderSelectionScreen(selectedService: service),
                  ),
                );
              },
              child: Icon(Icons.arrow_forward_ios, size: 20),
              backgroundColor: Colors.blue,
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: FadeInUp(
                child: Padding(
                  padding: EdgeInsets.only(top: 120.0, right: 20.0, left: 20.0),
                  child: Text(
                    'Which service \ndo you need?',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FadeInUp(
                      delay: Duration(milliseconds: 500 * index),
                      child: serviceContainer(
                        services[index].imageUrl,
                        services[index].name,
                        index,
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

  Widget serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedService = (selectedService == index) ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedService == index
              ? Colors.blue.withAlpha(25)
              : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index ? Colors.blue : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(image, height: 80),
            SizedBox(height: 20),
            Text(name, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
