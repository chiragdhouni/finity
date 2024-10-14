import 'dart:convert';
import 'package:finity/core/config/config.dart';
import 'package:finity/models/event_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventRepo {
  // Fetch events near a location
  Future<List<EventModel>> getEventsNearLocation(
      double longitude, double latitude,
      {double maxDistance = 10000}) async {
    try {
      final Map<String, String> queryParams = {
        'longitude': longitude.toString(),
        'latitude': latitude.toString(),
        'maxDistance': maxDistance.toString(),
      };

      final Uri url = Uri.parse("${Config.serverURL}events/near")
          .replace(queryParameters: queryParams);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        token = '';
        prefs.setString('x-auth-token', token);
      }

      final http.Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonEvents = jsonDecode(response.body);
        final List<EventModel> events = jsonEvents.map((json) {
          return EventModel.fromJson(json);
        }).toList();
        return events;
      } else {
        throw Exception('Failed to fetch events: ${response.reasonPhrase}');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Create a new event
  Future<EventModel> createEvent({
    required String title,
    required String image,
    required String description,
    required String ownerId,
    required String date,
    required String address,
    required Map<String, dynamic> location,
  }) async {
    try {
      final Uri url = Uri.parse("${Config.serverURL}events/addEvent");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        token = '';
        prefs.setString('x-auth-token', token);
      }

      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'title': title,
          'image': image,
          'description': description,
          'ownerId': ownerId,
          'date': date,
          'address': address,
          'location': location,
        }),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return EventModel.fromJson(json);
      } else {
        throw Exception('Failed to create event: ${response.reasonPhrase}');
      }
    } catch (error) {
      rethrow;
    }
  }
}
