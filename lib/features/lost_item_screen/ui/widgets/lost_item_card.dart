import 'package:finity/blocs/lost_item/lost_item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc
import 'package:finity/features/lost_item_screen/ui/screens/edit_lost_item_screen.dart';
import 'package:finity/features/lost_item_screen/ui/widgets/claim_item_form.dart';
import 'package:finity/models/lost_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LostItemCard extends StatefulWidget {
  final LostItem item;
  const LostItemCard({super.key, required this.item});

  @override
  State<LostItemCard> createState() => _LostItemCardState();
}

class _LostItemCardState extends State<LostItemCard> {
  @override
  Widget build(BuildContext context) {
    LostItem item = widget.item;
    final lostItemBloc = context.read<LostItemBloc>();
    final userBloc = context.read<UserBloc>();
    final userState = userBloc.state;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: BlocListener<LostItemBloc, LostItemState>(
        listener: (context, state) {
          if (state is LostItemDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Item deleted successfully')),
            );
            Navigator.pop(context); // Go back after deletion
          } else if (state is LostItemError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display item details...
              Text('Description: ${item.description}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Status: ${item.status}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Contact Info: ${item.contactInfo}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Date Lost: ${item.dateLost.toLocal()}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                  'Location: (${item.location.coordinates.first}, ${item.location.coordinates.last})',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ClaimItemForm.routeName,
                      arguments: item);
                },
                child:
                    Text('Claim Item', style: TextStyle(color: Colors.white)),
              ),
              if (userState is UserLoaded && userState.user.id == item.owner.id)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditLostItemScreen(item: item),
                          ),
                        );
                      },
                      child: Text('Edit Item',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        lostItemBloc
                            .add(deleteLostItemEvent(lostItemId: item.id));
                      },
                      child: Text('Delete Item',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              else
                Container(),
            ],
          ),
        ),
      ),
    );
  }
}
