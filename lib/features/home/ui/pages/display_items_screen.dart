import 'package:finity/blocs/item/item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc
import 'package:finity/features/home/ui/pages/item_detail_screen.dart';
import 'package:finity/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayItemsScreen extends StatefulWidget {
  const DisplayItemsScreen({super.key});
  static const routeName = '/displayItemsScreen';

  @override
  State<DisplayItemsScreen> createState() => _DisplayItemsScreenState();
}

class _DisplayItemsScreenState extends State<DisplayItemsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchNearbyItems();
  }

  void _fetchNearbyItems() {
    // Fetching user's current location from UserBloc
    UserState userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      double latitude = userState.user.location[0];
      double longitude = userState.user.location[1];

      // Dispatching FetchNearbyItemsEvent to ItemBloc
      context.read<ItemBloc>().add(FetchNearbyItemsEvent(
          latitude: latitude, longitude: longitude, maxDistance: 8000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          // Fetch nearby items again if the user's location changes
          _fetchNearbyItems();
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 30),
          BlocBuilder<ItemBloc, ItemState>(
            builder: (context, state) {
              if (state is ItemLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ItemFetched) {
                if (state.data == null || state.data!.isEmpty) {
                  return const Center(child: Text('No items found'));
                }
                return _buildItemList(state.data!);
              } else if (state is ItemError) {
                return Center(child: Text(state.error));
              }
              return const Center(child: Text('Unknown state'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(List<ItemModel> items) {
    return ListView.builder(
      shrinkWrap: true, // Allow ListView to take only the required height
      physics:
          const NeverScrollableScrollPhysics(), // Disable ListView's scrolling
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15.0),
              trailing: Text(
                item.dueDate.toString(),
                style: const TextStyle(color: Colors.white70),
              ),
              tileColor: Colors.grey[850],
              title: Text(
                item.name,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                item.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white60),
              ),
              onTap: () {
                // Navigate to item details screen
                Navigator.of(context).pushNamed(
                  ItemDetailScreen.routeName,
                  arguments: item,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
