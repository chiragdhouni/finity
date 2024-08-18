import 'package:finity/features/home/bloc/item_bloc/bloc/item_bloc.dart';
import 'package:finity/models/item_model.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  static const routeName = '/itemDetailScreen';
  final ItemModel item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserProvider>(context, listen: false).user.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: BlocConsumer<ItemBloc, ItemState>(
        listener: (context, state) {
          if (state is ItemBorrowSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item borrow request sent')),
            );
          } else if (state is ItemLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loading...')),
            );
          } else if (state is ItemBorrowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is ItemLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.item
                        .toMap()
                        .map((key, value) => MapEntry(key, '$value\n'))
                        .toString(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ItemBloc>().add(ItemBorrowEvent(
                            itemId: widget.item.id,
                            borrowerId: userId,
                          ));
                    },
                    child: const Text('Borrow'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
