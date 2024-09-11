import 'dart:async';
import 'package:finity/features/lost_item_screen/ui/widgets/lost_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finity/blocs/lost_item/lost_item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart';

import 'package:finity/models/lost_item_model.dart';

class NearByItemScreen extends StatefulWidget {
  const NearByItemScreen({super.key});

  @override
  State<NearByItemScreen> createState() => _NearByItemScreenState();
}

class _NearByItemScreenState extends State<NearByItemScreen> {
  @override
  void initState() {
    super.initState();
    _fetchNearbyItems();
  }

  void _fetchNearbyItems() {
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;

    if (userState is UserLoaded) {
      double latitude = userState.user.location[0];
      double longitude = userState.user.location[1];

      // Fetch nearby lost items
      context.read<LostItemBloc>().add(
            getNearByLostItemsEvent(
              latitude: latitude,
              longitude: longitude,
              maxDistance: 10000.0,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LostItemBloc, LostItemState>(
      listener: (context, state) {
        if (state is LostItemError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is LostItemLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is NearByLostItemSuccess) {
          if (state.lostItems.isEmpty) {
            return const Center(child: Text('No items found nearby'));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.lostItems.length,
            itemBuilder: (context, index) {
              final item = state.lostItems[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    item.description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () async {
                    // Navigate to LostItemDetailScreen and wait for result
                    final updatedItem = await Navigator.of(context).pushNamed(
                      LostItemDetailScreen.routeName,
                      arguments: item,
                    );

                    // Check if the item was updated or deleted, and refresh list
                    if (updatedItem == 'deleted' || updatedItem != null) {
                      _fetchNearbyItems(); // Refresh the list if the item was deleted or updated
                    }
                  },
                ),
              );
            },
          );
        } else if (state is LostItemError) {
          return Center(child: Text(state.message));
        }
        return Center(child: Text(state.toString()));
      },
    );
  }
}
