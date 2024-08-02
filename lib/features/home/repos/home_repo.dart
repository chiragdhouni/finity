import 'dart:convert';

import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<void> updateUserLocation({required BuildContext context}) async {
    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get user ID from UserProvider
    String userId = Provider.of<UserProvider>(context, listen: false).user.id;

    // Update location to the backend
    try {
      final response = await http.patch(
        Uri.parse('http://<your-server-url>/api/auth/$userId/location'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer <your-token>', // If required
        },
        body: jsonEncode(<String, double>{
          'latitude': position.latitude,
          'longitude': position.longitude,
        }),
      );

      if (response.statusCode == 200) {
        print('Location updated successfully');
      } else {
        print('Failed to update location: ${response.body}');
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }
}
