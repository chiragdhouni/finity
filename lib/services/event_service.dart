import 'dart:convert';
import 'dart:developer';
import 'package:finity/core/config/config.dart';
import 'package:finity/models/address_model.dart';
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
        'longitude': (-122.4194).toString(),
        'latitude': (37.7749).toString(),
        'maxDistance': maxDistance.toString(),
      };
      log('Query Params: $queryParams');

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
        log('Response: ${response.body}');
        final List<dynamic> jsonEvents = jsonDecode(response.body);
        log('Events: $jsonEvents');

        final List<EventModel> events = jsonEvents.map((json) {
          return EventModel.fromJson(json);
        }).toList();
        return events;
      } else {
        throw Exception('Failed to fetch events: ${response.reasonPhrase}');
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  // Create a new event
  Future<EventModel> createEvent({
    required String title,
    required List<String> image,
    required String description,
    required String ownerId,
    required DateTime date,
    required AddressModel address,
    required Location location,
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
          'date': date.toIso8601String(), // Ensure date is formatted correctly
          'address': address.toJson(), // Ensure address is converted to JSON
          'location': location.toJson(), // Ensure location is converted to JSON
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

  // Update an existing event
  Future<EventModel> updateEvent({
    required String eventId,
    required String title,
    required List<String> image,
    required String description,
    required DateTime date,
    required AddressModel address,
    required Location location,
  }) async {
    try {
      final Uri url = Uri.parse("${Config.serverURL}events/$eventId");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        token = '';
        prefs.setString('x-auth-token', token);
      }

      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'title': title,
          'image': image,
          'description': description,
          'date': date.toIso8601String(), // Ensure date is formatted correctly
          'address': address.toJson(), // Ensure address is converted to JSON
          'location': location.toJson(), // Ensure location is converted to JSON
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return EventModel.fromJson(json);
      } else {
        throw Exception('Failed to update event: ${response.reasonPhrase}');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      final Uri url = Uri.parse("${Config.serverURL}events/$eventId");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        token = '';
        prefs.setString('x-auth-token', token);
      }

      final http.Response response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        log('Event deleted successfully');
      } else {
        throw Exception('Failed to delete event: ${response.reasonPhrase}');
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }
}
