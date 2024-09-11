// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:finity/blocs/lost_item/lost_item_bloc.dart';
import 'package:finity/models/lost_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditLostItemScreen extends StatefulWidget {
  final LostItem item;
  const EditLostItemScreen({super.key, required this.item});

  @override
  _EditLostItemScreenState createState() => _EditLostItemScreenState();
}

class _EditLostItemScreenState extends State<EditLostItemScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _statusController;
  late TextEditingController _contactInfoController;
  late TextEditingController _ownerNameController;
  late TextEditingController _ownerEmailController;
  late TextEditingController _ownerAddressController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  DateTime? _dateLost;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the current item data
    _nameController = TextEditingController(text: widget.item.name);
    _descriptionController =
        TextEditingController(text: widget.item.description);
    _statusController = TextEditingController(text: widget.item.status);
    _contactInfoController =
        TextEditingController(text: widget.item.contactInfo);
    _ownerNameController = TextEditingController(text: widget.item.owner.name);
    _ownerEmailController =
        TextEditingController(text: widget.item.owner.email);
    _ownerAddressController =
        TextEditingController(text: widget.item.owner.address);
    _latitudeController = TextEditingController(
        text: widget.item.location.coordinates.first.toString());
    _longitudeController = TextEditingController(
        text: widget.item.location.coordinates.last.toString());
    _dateLost = widget.item.dateLost;
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    _nameController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();
    _contactInfoController.dispose();
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _ownerAddressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Lost Item'),
      ),
      body: BlocConsumer<LostItemBloc, LostItemState>(
        listener: (context, state) {
          if (state is LostItemUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item updated successfully!')),
            );
            Navigator.pop(context); // Go back to the previous screen
            log("Item updated successfully");
          } else if (state is LostItemError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is LostItemLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Form fields
                  _buildTextField(_nameController, 'Name'),
                  _buildTextField(_descriptionController, 'Description'),
                  _buildTextField(_statusController, 'Status'),
                  _buildTextField(_contactInfoController, 'Contact Info'),
                  _buildTextField(_ownerNameController, 'Owner Name'),
                  _buildTextField(_ownerEmailController, 'Owner Email'),
                  _buildTextField(_ownerAddressController, 'Owner Address'),
                  _buildTextField(_latitudeController, 'Latitude', true),
                  _buildTextField(_longitudeController, 'Longitude', true),
                  _buildDatePicker(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedItem = widget.item.copyWith(
                          name: _nameController.text,
                          description: _descriptionController.text,
                          status: _statusController.text,
                          contactInfo: _contactInfoController.text,
                          owner: widget.item.owner.copyWith(
                            name: _ownerNameController.text,
                            email: _ownerEmailController.text,
                            address: _ownerAddressController.text,
                          ),
                          location: Location(
                            type: "Point",
                            coordinates: [
                              double.parse(_latitudeController.text),
                              double.parse(_longitudeController.text),
                            ],
                          ),
                          dateLost: _dateLost!,
                        );

                        context
                            .read<LostItemBloc>()
                            .add(updateLostItemEvent(lostItem: updatedItem));
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [bool isNumber = false]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text(_dateLost == null
          ? 'Select Date Lost'
          : 'Date Lost: ${_dateLost!.toLocal()}'.split(' ')[0]),
      trailing: const Icon(Icons.calendar_today),
      onTap: _selectDateLost,
    );
  }

  Future<void> _selectDateLost() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateLost ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateLost) {
      setState(() {
        _dateLost = picked;
      });
    }
  }
}
