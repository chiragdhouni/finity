// import 'dart:developer';

// ignore_for_file: annotate_overrides

import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/services/auth_service.dart';
import 'package:finity/services/location_service.dart';
import 'package:finity/features/home/ui/pages/home_screen.dart';
import 'package:finity/features/profile/ui/screens/profile_screen.dart';
import 'package:finity/features/lost_item_screen/ui/screens/lost_item_screen.dart';
import 'package:finity/features/notification/ui/screens/notification_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  static const routeName = '/bottomNavBar';

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final AuthService authService = AuthService(userBloc: UserBloc());
  final List<Widget> _widgetOptions = <Widget>[
    App(
      authService: AuthService(userBloc: UserBloc()),
    ),
    // ItemSearchPage(),
    Text('Search by category'),
    LostItemScreen(),
    NotificationScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    _updateUserLocationIfNeeded();
  }

  Future<void> _updateUserLocationIfNeeded() async {
    // Commented out Provider code
    // UserProvider userProvider =
    //     Provider.of<UserProvider>(context, listen: false);

    // Use the UserBloc to get the current user state
    UserState state = context.read<UserBloc>().state;

    if (state is UserLoaded) {
      // Check if location is empty or contains invalid coordinates
      if (state.user.location.isEmpty ||
          state.user.location[0] == 0.0 ||
          state.user.location[1] == 0.0 ||
          state.user.location[0] == 0 ||
          state.user.location[1] == 0) {
        Position position = await LocationService.getCurrentLocation();
        double latitude = position.latitude;
        double longitude = position.longitude;

        // Dispatch UpdateLocation event to update the user's location
        context.read<UserBloc>().add(UpdateLocation(latitude, longitude));
        // Location updated
      }
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
            label: 'Search by category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.luggage),
            label: 'Lost and found',
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
        onTap: (int index) async {
          // await authService.getUserData(context);
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      // Wrapping the body in BlocListener to listen for UserState changes
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          // Handle additional state changes if necessary
          if (state is UserError) {
            // Show an error message if there's an error in the user state
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
