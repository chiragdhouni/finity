import 'package:finity/blocs/item/item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/models/item_model.dart';
import 'package:finity/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For formatting dates

class ItemDetailScreen extends StatefulWidget {
  static const routeName = '/itemDetailScreen';
  final ItemModel item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late UserModel user;
  // Access current user details from UserBloc

  initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;

    if (userState is UserLoaded) {
      user = userState.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userId =
        (context.read<UserBloc>().state as UserLoaded).user.id;

    // Format the due date for better readability
    final String formattedDueDate =
        DateFormat.yMMMd().format(widget.item.dueDate);

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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name
                    Text(
                      widget.item.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Item Description
                    Text(
                      widget.item.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    // Category and Status
                    Row(
                      children: [
                        Chip(
                          label: Text(widget.item.category),
                          backgroundColor: Colors.blueAccent,
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(widget.item.status),
                          backgroundColor: widget.item.status == 'available'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Owner Information
                    Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text('Owner: ${widget.item.owner.name}'),
                        subtitle: Text('Email: ${widget.item.owner.email}\n'
                            'Address: ${widget.item.owner.address.address}, ${widget.item.owner.address.city}, ${widget.item.owner.address.state}, ${widget.item.owner.address.country}'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Borrower Information (if any)
                    if (widget.item.borrower != null)
                      Card(
                        elevation: 3,
                        child: ListTile(
                          title:
                              Text('Borrower: ${widget.item.borrower!.name}'),
                          subtitle: Text(
                              'Email: ${widget.item.borrower!.email ?? "N/A"}'),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Due Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Text(
                          'Due Date: $formattedDueDate',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Location Information
                    if (widget.item.location.coordinates.isNotEmpty)
                      Card(
                        elevation: 3,
                        child: ListTile(
                          title: const Text('Location'),
                          subtitle: Text('Coordinates: '
                              '${widget.item.location.coordinates[1]}, ${widget.item.location.coordinates[0]}'),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Images (if any)
                    if (widget.item.images != null &&
                        widget.item.images!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Images:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: widget.item.images!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              return Image.network(
                                widget.item.images![index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                    // Borrow Button (only if item is available)
                    if (widget.item.status == 'available')
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final confirm =
                                await _showBorrowConfirmationDialog(context);
                            if (confirm == true) {
                              context.read<ItemBloc>().add(
                                    ItemBorrowEvent(
                                      itemId: widget.item.id,
                                      borrowerId: userId,
                                    ),
                                  );
                            }
                          },
                          child: user.itemsRequested.contains(widget.item.id)
                              ? const Text('Borrow Requested')
                              : const Text('Borrow Item'),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<bool?> _showBorrowConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Borrow'),
        content: const Text('Do you want to borrow this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
