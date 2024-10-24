import 'dart:developer';

import 'package:finity/models/address_model.dart';
import 'package:finity/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finity/blocs/lost_item/lost_item_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc

class AddLostItemScreen extends StatefulWidget {
  static const routeName = '/addLostItemScreen';

  const AddLostItemScreen({super.key});

  @override
  State<AddLostItemScreen> createState() => _AddLostItemScreenState();
}

class _AddLostItemScreenState extends State<AddLostItemScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateLostController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _ownerIdController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _ownerAddressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  late UserBloc userBloc = context.read<UserBloc>();
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = (userBloc.state as UserLoaded).user;
    _prefillTextFieldsWithUserData();
  }

  void _prefillTextFieldsWithUserData() {
    // Prefill fields with user data
    _ownerIdController.text = user.id;
    _ownerNameController.text = user.name;
    _ownerEmailController.text = user.email;
    _ownerAddressController.text = user.address.address ?? '';
    _latitudeController.text =
        user.location.isNotEmpty ? user.location[1].toString() : '';
    _longitudeController.text =
        user.location.isNotEmpty ? user.location[0].toString() : '';
    _stateController.text = user.address.state ?? '';
    _cityController.text = user.address.city ?? '';
    _zipCodeController.text = user.address.zipCode ?? '';
    _countryController.text = user.address.country ?? '';
    _dateLostController.text = DateTime.now().toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Lost Item'),
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
              } else if (state is LostItemError) {
                // Show a snackbar to indicate that an error occurred
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error creating lost item: ${state.message}'),
                  ),
                );
              } else if (state is LostItemLoading) {
                // Show a loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Creating lost item...'),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Item Name
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                  ),
                  const SizedBox(height: 10),
                  // Description
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 10),
                  // Date Lost
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
                        decoration: const InputDecoration(
                          labelText: 'Date Lost',
                          hintText: 'YYYY-MM-DD',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Contact Info
                  TextField(
                    controller: _contactInfoController,
                    decoration:
                        const InputDecoration(labelText: 'Contact Info'),
                  ),
                  const SizedBox(height: 10),
                  // Owner Address
                  TextField(
                    controller: _ownerAddressController,
                    decoration:
                        const InputDecoration(labelText: 'Owner Address'),
                  ),
                  const SizedBox(height: 10),
                  // State
                  TextField(
                    controller: _stateController,
                    decoration: const InputDecoration(labelText: 'State'),
                  ),
                  const SizedBox(height: 10),
                  // City
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  const SizedBox(height: 10),
                  // Zip Code
                  TextField(
                    controller: _zipCodeController,
                    decoration: const InputDecoration(labelText: 'Zip Code'),
                  ),
                  const SizedBox(height: 10),
                  // Country
                  TextField(
                    controller: _countryController,
                    decoration: const InputDecoration(labelText: 'Country'),
                  ),
                  const SizedBox(height: 10),
                  // Latitude and Longitude
                  const SizedBox(height: 20),
                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      // Log the submission process
                      log("Submit button clicked");

                      AddressModel address = AddressModel(
                        address: _ownerAddressController.text,
                        city: _cityController.text,
                        state: _stateController.text,
                        country: _countryController.text,
                        zipCode: _zipCodeController.text,
                      );

                      context.read<LostItemBloc>().add(
                            CreateLostItemEvent(
                              name: _nameController.text,
                              description: _descriptionController.text,
                              address: address,
                              status: "lost",
                              dateLost:
                                  DateTime.parse(_dateLostController.text),
                              contactInfo: _contactInfoController.text,
                              user: user,
                              latitude:
                                  double.tryParse(_latitudeController.text) ??
                                      0.0,
                              longitude:
                                  double.tryParse(_longitudeController.text) ??
                                      0.0,
                            ),
                          );
                      log("Lost item creation event triggered");
                      Navigator.pop(context, "added");
                    },
                    child: const Text('Submit'),
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
