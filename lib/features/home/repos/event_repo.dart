import 'dart:convert';
import 'dart:developer';

import 'package:finity/core/config/config.dart';
import 'package:finity/models/event_model.dart';
import 'package:finity/models/item_model.dart';
import 'package:http/http.dart' as http;

// Your existing models: EventModel, Owner, Location

class EventRepo {
  Future<List<EventModel>> getEventsNearLocation(
      double longitude, double latitude,
      {double maxDistance = 10000}) async {
    try {
      // Construct the query parameters
      final Map<String, String> queryParams = {
        'longitude': longitude.toString(),
        'latitude': latitude.toString(),
        'maxDistance': maxDistance.toString(),
      };

      // Build the complete URL with query parameters
      final Uri url = Uri.parse("${Config.serverURL}events/near")
          .replace(queryParameters: queryParams);

      // Make the API request using http.get
      final http.Response response = await http.get(url);

      log('Response: ${response.body} ${response.statusCode}');

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> jsonEvents = jsonDecode(response.body);

        // Map the JSON data to EventModel instances and return the list
        final List<EventModel> events = jsonEvents.map((json) {
          return EventModel.fromJson(json);
        }).toList();

        log('Events near location: $events');
        return events;
      } else {
        throw Exception('Failed to fetch events: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle any errors that occur during the fetch
      log('Error fetching events near location: $error');
      throw error;
    }
  }
}
