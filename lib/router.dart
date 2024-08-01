import 'package:finity/features/auth/ui/pages/login_page.dart';
import 'package:finity/features/auth/ui/pages/signup_page.dart';
import 'package:finity/features/home/bottom_nav_bar.dart';
import 'package:finity/features/home/ui/pages/home_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginPage(),
      );

    case SignUpPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpPage(),
      );

    case BottomNavBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomNavBar(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
