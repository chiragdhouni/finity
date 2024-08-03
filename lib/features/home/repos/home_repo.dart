import 'dart:convert';
import 'dart:developer';
import 'package:finity/core/config/config.dart';
import 'package:http/http.dart' as http;

class HomeService {
  static Future<void> updateUserLocation(
      String userId, double latitude, double longitude) async {
    final url = Uri.parse('${Config.serverURL}auth/$userId/location');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode == 200) {
      // Optionally handle the successful response
      log('Location updated successfully');
    } else {
      // Include more detail about the failure
      log('Failed to update location: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to update location: ${response.body}');
    }
  }
}
