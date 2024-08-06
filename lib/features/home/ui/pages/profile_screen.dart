import 'package:finity/features/auth/models/user_model.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel userData;

  @override
  void initState() {
    super.initState();
    userData = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    List<String> itemBorrowed = userData.itemsBorrowed;
    List<String> itemLended = userData.itemsLended;
    List<String> itemRequested = userData.itemsRequested;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1664193314424-7f823ccaa301?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            userData.name,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            userData.email,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            userData.address,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Card(
                    color: Colors.grey[850],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Items Lended',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: itemLended.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(itemLended[index],
                                      style: TextStyle(color: Colors.white)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.grey[850],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Items Borrowed',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: itemBorrowed.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(itemBorrowed[index],
                                      style: TextStyle(color: Colors.white)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.grey[850],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Items Requested',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: itemRequested.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(itemRequested[index],
                                      style: TextStyle(color: Colors.white)),
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
        ],
      ),
    );
  }
}
