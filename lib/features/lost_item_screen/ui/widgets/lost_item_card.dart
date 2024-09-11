import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finity/blocs/lost_item/lost_item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/features/lost_item_screen/ui/screens/edit_lost_item_screen.dart';
import 'package:finity/features/lost_item_screen/ui/widgets/claim_item_form.dart';
import 'package:finity/models/lost_item_model.dart';

class LostItemDetailScreen extends StatefulWidget {
  final LostItem item;
  static const routeName = '/lost-item-detail';
  const LostItemDetailScreen({super.key, required this.item});

  @override
  State<LostItemDetailScreen> createState() => _LostItemDetailScreenState();
}

class _LostItemDetailScreenState extends State<LostItemDetailScreen> {
  LostItem? updatedItem;

  @override
  Widget build(BuildContext context) {
    LostItem item = updatedItem ?? widget.item;

    final lostItemBloc = context.read<LostItemBloc>();
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, updatedItem ?? widget.item);
          },
        ),
        title: Text(item.name),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: BlocConsumer<LostItemBloc, LostItemState>(
        listener: (context, state) {
          if (state is LostItemUpdateSuccess) {
            setState(() {
              updatedItem = state.lostItem;
            });
          } else if (state is LostItemDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item deleted successfully')),
            );

            Navigator.pop(context, 'deleted');
          } else if (state is LostItemError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Status: ${item.status}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Contact Info: ${item.contactInfo}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Date Lost: ${item.dateLost.toLocal()}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Location: (${item.location.coordinates.first}, ${item.location.coordinates.last})',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ClaimItemForm.routeName,
                        arguments: item);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Claim Item',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                if (userState is UserLoaded &&
                    userState.user.id == item.owner.id)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Navigate to EditLostItemScreen and wait for updated item
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditLostItemScreen(item: item),
                              ),
                            );

                            if (result != null) {
                              lostItemBloc.add(updateLostItemEvent(
                                  lostItem: result as LostItem));
                              setState(() {
                                updatedItem = result;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Edit Item',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            lostItemBloc
                                .add(deleteLostItemEvent(lostItemId: item.id));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Delete Item',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
