import 'package:finity/blocs/item/item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailScreen extends StatefulWidget {
  static const routeName = '/itemDetailScreen';
  final ItemModel item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Accessing userId from a bloc (you could use a UserBloc if applicable)
    final String userId =
        (context.read<UserBloc>().state as UserLoaded).user.id;

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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${widget.item.name}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Description: ${widget.item.description}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Due Date: ${widget.item.dueDate.toLocal()}',
                    style: const TextStyle(fontSize: 16),
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
