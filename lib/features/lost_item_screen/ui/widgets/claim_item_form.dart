import 'dart:developer';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:finity/features/lost_item_screen/bloc/bloc/lost_item_bloc.dart';
import 'package:finity/models/lost_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ClaimItemForm extends StatefulWidget {
  static const routeName = '/claim-item-form';
  final LostItem item;
  const ClaimItemForm({super.key, required this.item});

  @override
  State<ClaimItemForm> createState() => _ClaimItemFormState();
}

class _ClaimItemFormState extends State<ClaimItemForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _proofTextController = TextEditingController();
  List<XFile>? _proofImages = [];
  final CloudinaryPublic cloudinary =
      CloudinaryPublic('dgbngfw1e', 'asdfghjk', cache: false);

  Future<List<String>> _uploadImagesToCloudinary(List<XFile> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path,
              resourceType: CloudinaryResourceType.Image),
        );
        imageUrls.add(response.secureUrl);
      } catch (e) {
        log('Error uploading image: $e');
      }
    }
    return imageUrls;
  }

  void _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    setState(() {
      if (images != null) {
        _proofImages = images;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Claim')),
      body: BlocListener<LostItemBloc, LostItemState>(
        listener: (context, state) {
          if (state is SubmitClaimSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Claim submitted successfully!')),
            );
            Navigator.pop(context);
          } else if (state is LostItemError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _proofTextController,
                  decoration: const InputDecoration(
                    labelText: 'Proof Text',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter proof text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('Pick Images'),
                ),
                const SizedBox(height: 10),
                _proofImages != null && _proofImages!.isNotEmpty
                    ? Wrap(
                        children: _proofImages!.map((image) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.file(
                              File(image.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      )
                    : const Text('No images selected'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Upload images to Cloudinary and get URLs
                      List<String> imageUrls =
                          await _uploadImagesToCloudinary(_proofImages!);

                      // Send URLs and proof text to the BLoC
                      BlocProvider.of<LostItemBloc>(context).add(
                        SubmitClaimEvent(
                          lostItemId: widget.item.id,
                          proofText: _proofTextController.text,
                          proofImages: imageUrls, // Send the Cloudinary URLs
                        ),
                      );
                    }
                  },
                  child: const Text('Submit Claim'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _proofTextController.dispose();
    super.dispose();
  }
}
