import 'dart:io';
import 'package:finity/blocs/event/ad_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart';
import 'package:finity/models/address_model.dart';
import 'package:finity/models/event_model.dart';
import 'package:finity/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  List<XFile> images = [];
  DateTime? date;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerContactController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  final _imagePicker = ImagePicker();

  late UserBloc userBloc = context.read<UserBloc>();
  late UserModel user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = (userBloc.state as UserLoaded).user;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    userBloc.stream.listen((state) {
      if (state is UserLoaded) {
        final user = state.user;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ownerNameController.dispose();
    _ownerContactController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _zipCodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        images.addAll(pickedFiles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AdBloc, AdState>(
          listener: (context, state) {
            if (state is AdSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event created successfully!'),
                ),
              );
            } else if (state is AdError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error creating event: ${state.error}'),
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Date
                  ListTile(
                    title: Text(date == null
                        ? 'Pick Event Date'
                        : DateFormat.yMMMd().format(date!)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _pickDate(context),
                  ),
                  const SizedBox(height: 16),
                  // Owner Details
                  TextFormField(
                    controller: _ownerNameController,
                    decoration: const InputDecoration(labelText: 'Owner Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter owner\'s name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ownerContactController,
                    decoration:
                        const InputDecoration(labelText: 'Owner Contact'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter owner\'s contact';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Address
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(labelText: 'State'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(labelText: 'Country'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _zipCodeController,
                    decoration: const InputDecoration(labelText: 'Zip Code'),
                  ),
                  const SizedBox(height: 16),
                  // Location (latitude, longitude)
                  TextFormField(
                    controller: _latitudeController,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _longitudeController,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                  ),
                  const SizedBox(height: 16),
                  // Image Picker
                  ListTile(
                    title: const Text('Pick Event Images'),
                    trailing: const Icon(Icons.image),
                    onTap: _pickImage,
                  ),
                  if (images.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(File(images[index].path)),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 32),
                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final owner = Owner(
                          id: '', // Set this dynamically if needed
                          name: _ownerNameController.text,
                          email: _ownerContactController.text,
                          address: AddressModel(
                            address: _addressController.text,
                            city: _cityController.text,
                            state: _stateController.text,
                            country: _countryController.text,
                            zipCode: _zipCodeController.text,
                          ),
                        );
                        final location = Location(
                          type: 'Point',
                          coordinates: [
                            double.parse(_latitudeController.text),
                            double.parse(_longitudeController.text),
                          ],
                        );

                        // Dispatch AddAdEvent to the bloc
                        context.read<AdBloc>().add(
                              AddAdEvent(
                                ownerId: user.id,
                                title: _titleController.text,
                                image: images
                                    .map((image) => image.path)
                                    .toList(), // Use list of image paths
                                description: _descriptionController.text,

                                date: date!,
                                address:
                                    owner.address, // Use the owner's address
                                location: location,
                              ),
                            );
                      }
                    },
                    child: const Text('Submit Event'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
