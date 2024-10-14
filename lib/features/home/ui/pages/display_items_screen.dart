import 'package:finity/blocs/item/item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc
import 'package:finity/features/home/ui/pages/item_detail_screen.dart';
import 'package:finity/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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

  // Fetch nearby items based on user's location
  void _fetchNearbyItems() {
    UserState userState = context.read<UserBloc>().state;

    if (userState is UserLoaded) {
      double latitude = userState.user.location[0];
      double longitude = userState.user.location[1];

      context.read<ItemBloc>().add(FetchNearbyItemsEvent(
            latitude: latitude,
            longitude: longitude,
            maxDistance: 8000,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          // Refetch nearby items if user's location changes
          _fetchNearbyItems();
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 30),
          _buildItemContent(),
        ],
      ),
    );
  }

  Widget _buildItemContent() {
    return BlocBuilder<ItemBloc, ItemState>(
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
    );
  }

  Widget _buildItemList(List<ItemModel> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(item, index);
      },
    );
  }

  Widget _buildItemCard(ItemModel item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(15.0),
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
          leading: CircleAvatar(
            backgroundColor: Colors.purple[400],
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Chip(
                label: Text(
                  item.status,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: item.status == 'Borrowed'
                    ? Colors.red[400]
                    : Colors.green[400],
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.category, color: Colors.white60, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    item.category,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      color: Colors.white60, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    item.location.toString(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.white60, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    'Owner: ${item.owner.name}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              if (item.borrower != null)
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        color: Colors.white60, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      'Borrower: ${item.borrower!.name}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.date_range, color: Colors.white60, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    'Due: ${DateFormat.yMMMd().format(item.dueDate)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
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
  }
}
