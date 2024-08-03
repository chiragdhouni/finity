// ignore_for_file: prefer_const_constructors

import 'package:finity/features/home/ui/widgets/card.dart';
import 'package:finity/features/home/ui/widgets/event_slider.dart';
import 'package:finity/features/home/ui/widgets/lost_item_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/homeScreen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Navigator.pushNamed(context, '/loginPage');
            },
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
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
    );
  }
}
