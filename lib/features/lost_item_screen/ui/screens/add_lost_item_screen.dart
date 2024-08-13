import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finity/features/lost_item_screen/bloc/bloc/lost_item_bloc.dart';
import 'package:provider/provider.dart';

class AddLostItemScreen extends StatefulWidget {
  static const routeName = '/addLostItemScreen';

  @override
  State<AddLostItemScreen> createState() => _AddLostItemScreenState();
}

class _AddLostItemScreenState extends State<AddLostItemScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _dateLostController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _ownerIdController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _ownerAddressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accessing the UserProvider after the widget tree is built
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _ownerIdController.text = user.id;
    _ownerNameController.text = user.name;
    _ownerEmailController.text = user.email;
    _ownerAddressController.text = user.address;
    _latitudeController.text = user.location[1].toString();
    _longitudeController.text = user.location[0].toString();
    _dateLostController.text = DateTime.now().toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Lost Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: BlocConsumer<LostItemBloc, LostItemState>(
            listener: (context, state) {
              if (state is lostItemCreated) {
                // Show a snackbar to indicate that the item was created
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Lost item ${state.lostItem.name} created successfully!'),
                  ),
                );
              }
              if (state is LostItemError) {
                // Show a snackbar to indicate that an error occurred
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error creating lost item: ${state.message}'),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 5, // Allows up to 5 lines for the description
                  ),
                  TextField(
                    controller: _statusController,
                    decoration: InputDecoration(labelText: 'Status'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _dateLostController.text =
                            pickedDate.toString().split(' ')[0]; // YYYY-MM-DD
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dateLostController,
                        decoration: InputDecoration(
                          labelText: 'Date Lost',
                          hintText: 'YYYY-MM-DD',
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _contactInfoController,
                    decoration: InputDecoration(labelText: 'Contact Info'),
                  ),
                  TextField(
                    controller: _ownerIdController,
                    decoration: InputDecoration(labelText: 'Owner ID'),
                  ),
                  TextField(
                    controller: _ownerNameController,
                    decoration: InputDecoration(labelText: 'Owner Name'),
                  ),
                  TextField(
                    controller: _ownerEmailController,
                    decoration: InputDecoration(labelText: 'Owner Email'),
                  ),
                  TextField(
                    controller: _ownerAddressController,
                    decoration: InputDecoration(labelText: 'Owner Address'),
                  ),
                  TextField(
                    controller: _latitudeController,
                    decoration: InputDecoration(labelText: 'Latitude'),
                  ),
                  TextField(
                    controller: _longitudeController,
                    decoration: InputDecoration(labelText: 'Longitude'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Trigger the event to create the lost item using the bloc
                      context.read<LostItemBloc>().add(
                            CreateLostItemEvent(
                              name: _nameController.text,
                              description: _descriptionController.text,
                              status: _statusController.text,
                              dateLost:
                                  DateTime.parse(_dateLostController.text),
                              contactInfo: _contactInfoController.text,
                              ownerId: _ownerIdController.text,
                              ownerName: _ownerNameController.text,
                              ownerEmail: _ownerEmailController.text,
                              ownerAddress: _ownerAddressController.text,
                              latitude: double.parse(_latitudeController.text),
                              longitude:
                                  double.parse(_longitudeController.text),
                            ),
                          );
                    },
                    child: Text('Submit'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
