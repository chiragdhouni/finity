import 'dart:developer';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final CloudinaryPublic cloudinary =
      CloudinaryPublic('dgbngfw1e', 'asdfghjk', cache: false);

  Future<String> uploadImageToCloudinary(File image) async {
    String imageUrl = "";

    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image),
      );
      imageUrl = response.secureUrl;
      log('Image uploaded to cloudinary: $imageUrl');
    } catch (e) {
      log('Error uploading image: $e');
    }
    return imageUrl;
  }
}
