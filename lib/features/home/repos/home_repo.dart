import 'dart:convert';
import 'package:http/http.dart' as http;

class Config {
  static const serverURL =
      'your-server-url-here'; // Replace with your server URL
}

class HomeService {
  static Future<void> updateUserLocation(
      String userId, double latitude, double longitude) async {
    final response = await http.put(
      Uri.parse('${Config.serverURL}auth/$userId/location'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update location');
    }
  }
}
