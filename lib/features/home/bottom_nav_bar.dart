// import 'dart:developer';

// ignore_for_file: annotate_overrides

import 'package:finity/features/auth/repos/auth_repo.dart';
import 'package:finity/features/home/services/location_service.dart';
import 'package:finity/features/home/ui/pages/home_screen.dart';
import 'package:finity/features/home/ui/pages/profile_screen.dart';
import 'package:finity/features/lost_item_screen/ui/screens/lost_item_screen.dart';
import 'package:finity/features/notification/ui/screens/notification_screen.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  static const routeName = '/bottomNavBar';
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    App(
      authService: AuthService(),
    ),
    // ItemSearchPage(),
    Text('Search by category'),
    LostItemScreen(),
    NotificationScreen(),
    ProfileScreen()
  ];

  void initState() {
    super.initState();
    _updateUserLocationIfNeeded();
  }

  Future<void> _updateUserLocationIfNeeded() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    // Check if location is empty or contains invalid coordinates
    if (userProvider.user.location[0] == 0.0 ||
        userProvider.user.location[1] == 0.0 ||
        userProvider.user.location[0] == 0 ||
        userProvider.user.location[1] == 0) {
      Position position = await LocationService.getCurrentLocation();
      // log('Position: $position.latitude, $position.longitude');
      double latitude = position.latitude;
      double longitude = position.longitude;

      // Update user location
      await userProvider.updateLocation(latitude, longitude);
      //location updated
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'seach by category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.luggage),
            label: 'lost and found',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
