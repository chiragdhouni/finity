// ignore_for_file: prefer_const_constructors

import 'package:finity/features/auth/bloc/auth_bloc.dart';
import 'package:finity/features/auth/repos/auth_repo.dart';
import 'package:finity/features/home/ui/widgets/card.dart';
import 'package:finity/features/home/ui/widgets/event_slider.dart';
import 'package:finity/features/home/ui/widgets/lost_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  final AuthService authService; // Pass in your AuthService
  static const routeName = '/appScreen';

  App({required this.authService});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(widget.authService),
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                // Navigate to the login screen when the user is logged out
                setState(() {
                  Navigator.of(context).pushReplacementNamed('/loginScreen');
                });
              }
              if (state is AuthErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
              if (state is AuthLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Loading...'),
                  ),
                );
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Welcome to Finity',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Add logout functionality here
                      context
                          .read<AuthBloc>()
                          .add(AuthLogoutEvent(context: context));
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 20),
                child: Column(
                  children: [
                    ResponsiveCardLayout(),
                    const SizedBox(
                      height: 15,
                    ),
                    EventSlider(),
                    SizedBox(
                      height: 17,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lost Items',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LostItemList(),
                  ],
                ),
              ),
            )));
  }
}

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   // static const routeName = '/homeScreen';
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return 
// }
