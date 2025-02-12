import 'dart:developer';

import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc
import 'package:finity/features/profile/ui/enum/ItemType.dart';
import 'package:finity/features/profile/ui/widgets/Item_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // log('Profile screen initialized');
    // Refetch user data

    // final currentState = userBloc.state;
    // if (currentState is UserLoaded) {
    //   userBloc.add(LoadUserEvent());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          log('User data: ${state.user.toString()}');
        }
      },
      builder: (context, state) {
        log(state.toString());
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          final userData = state.user;

          // Extract lists for display
          final List<String> itemBorrowed = userData.itemsBorrowed;
          final List<String> itemLended = userData.itemsLended;
          final List<String> itemRequested = userData.itemsRequested;
          final List<String> itemListed = userData.itemsListed;
          final List<String> events = userData.events;

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
                backgroundColor: Colors.transparent,
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(height: 20),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: const NetworkImage(
                              "https://images.unsplash.com/photo-1664193314424-7f823ccaa301?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  userData.email,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  userData.address.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ])
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoCard(ItemType.Lended, itemLended),
                      const SizedBox(height: 20),
                      _buildInfoCard(ItemType.Borrowed, itemBorrowed),
                      const SizedBox(height: 20),
                      _buildInfoCard(ItemType.Requested, itemRequested),
                      const SizedBox(height: 20),
                      _buildInfoCard(ItemType.Listed, itemListed),
                      // const SizedBox(height: 20),
                      // _buildInfoCard('Events', events),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is UserError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildInfoCard(ItemType type, List<String> items) {
    String text = 'Item ';
    switch (type) {
      case ItemType.Lended:
        text += 'Lended';
        break;
      case ItemType.Borrowed:
        text += 'Borrowed';
        break;
      case ItemType.Requested:
        text += 'Requested';
        break;
      case ItemType.Listed:
        text += 'Listed';
        break;
    }
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(ItemCard.routeName, arguments: {
            'type': type,
            'itemsids': items,
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
