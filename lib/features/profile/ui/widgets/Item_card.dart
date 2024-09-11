// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finity/blocs/item/item_bloc.dart';
import 'package:finity/features/profile/ui/widgets/item_detail.dart';
import 'package:flutter/material.dart';

import 'package:finity/features/profile/ui/enum/ItemType.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemCard extends StatefulWidget {
  final ItemType type;
  final List<String> itemsids;
  static const routeName = '/item-card';
  const ItemCard({
    Key? key,
    required this.type,
    required this.itemsids,
  }) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  void initState() {
    super.initState();

    // Dispatch the event to fetch items by IDs in bulk
    context.read<ItemBloc>().add(getItemByIdsEvent(widget.itemsids));
  }

  @override
  Widget build(BuildContext context) {
    String title = "Item ";
    switch (widget.type) {
      case ItemType.Borrowed:
        title += "Borrowed";
        break;
      case ItemType.Lended:
        title += "Lended";
        break;
      case ItemType.Requested:
        title += "Requested";
        break;
      case ItemType.Listed:
        title += "Listed";
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemByIdsFetched) {
            // Now using the fetched ItemModel list instead of item IDs
            return ListView.builder(
              itemCount: state.items.length, // Use the actual items count
              itemBuilder: (context, index) {
                final item = state.items[index]; // Access each ItemModel
                return Container(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      ItemDetail.routeName,
                      arguments: item,
                    ),
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(item.name),
                                subtitle: Text(
                                  item.description,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                title: Text('Category: ${item.category}'),
                                subtitle: Text('Status: ${item.status}'),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ItemError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('No items found.'));
          }
        },
      ),
    );
  }
}
