import 'dart:developer';

import 'package:finity/models/user_model.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        UserModel userData = userProvider.user;

        // Extract lists for display
        List<String> itemBorrowed = userData.itemsBorrowed;
        List<String> itemLended = userData.itemsLended;
        List<String> itemRequested = userData.itemsRequested;
        List<String> itemListed = userData.itemsListed;
        List<String> events = userData.events;

        log('User data: ${userData.toString()}');

        return Scaffold(
          appBar: AppBar(
            title: Text('Profile',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1664193314424-7f823ccaa301?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData.name,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData.email,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData.address,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150, // Fixed height for the card
                    child: Card(
                      color: Colors.grey[850],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Items Lended',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: itemLended.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(itemLended[index],
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150, // Fixed height for the card
                    child: Card(
                      color: Colors.grey[850],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Items Borrowed',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: itemBorrowed.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(itemBorrowed[index],
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150, // Fixed height for the card
                    child: Card(
                      color: Colors.grey[850],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Items Requested',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: itemRequested.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(itemRequested[index],
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150, // Fixed height for the card
                    child: Card(
                      color: Colors.grey[850],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Items Listed',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: itemListed.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(itemListed[index],
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150, // Fixed height for the card
                    child: Card(
                      color: Colors.grey[850],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Events',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(events[index],
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
