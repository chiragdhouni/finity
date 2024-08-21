// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:finity/core/config/config.dart';
import 'package:finity/models/item_model.dart';
import 'package:http/http.dart' as http;

class HomeRepo {
  //add item to lend others
  Future<void> addItem(String userId, String itemName, String description,
      String itemCategory, DateTime dueDate) async {
    ItemModel item = ItemModel(
      id: "",
      name: itemName,
      description: description,
      category: itemCategory,
      status: "available",
      owner: Owner(
        id: userId,
        name: "",
        email: "",
        address: "",
      ),
      dueDate: dueDate,
      location: Location(
        type: "Point",
        coordinates: [],
      ),
    );
    try {
      // Convert the item to a JSON map
      Map<String, dynamic> itemJson = item.toMap();

      // Add the ownerId to the JSON map
      itemJson['ownerId'] = userId;

      // Encode the JSON map to a JSON string
      String body = jsonEncode(itemJson);

      log('body is : $body');

      http.Response res = await http.post(
        Uri.parse('${Config.serverURL}items/add'),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      log(res.body);
      if (res.statusCode != 201) {
        log(res.statusCode.toString());
        throw Exception(res.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<ItemModel>?> fetchNearbyItems(
      double latitude, double longitude, double maxDistance) async {
    final String apiUrl = '${Config.serverURL}items/nearby';
    // final uri = Uri.parse(apiUrl).replace(
    //   queryParameters: {
    //     'latitude': latitude.toString(),
    //     'longitude': longitude.toString(),
    //     'maxDistance': maxDistance.toString(),
    //   },
    // );

    try {
      log('latitude: $latitude, longitude: $longitude, maxDistance: $maxDistance');
      log(latitude.runtimeType.toString());
      final response = await http.get(
        Uri.parse(apiUrl).replace(
          queryParameters: {
            'latitude': longitude.toDouble().toString(),
            'longitude': latitude.toDouble().toString(),
            'maxDistance': maxDistance.toDouble().toString(),
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      log('Response: ${response.body}  ${response.statusCode}');

      if (response.statusCode == 200) {
        List<ItemModel> data = (json.decode(response.body) as List)
            .map((e) => ItemModel.fromMap(e))
            .toList();
        log('Nearby Items: $data');
        // Handle the data (e.g., update state or use in the UI)
        return data;
      } else {
        throw Exception('Failed to load nearby items');
      }
    } catch (error) {
      log('Error fetching nearby items: $error');
    }
    return null;
  }

  Future<List<ItemModel>> searchItems(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.serverURL}items/search?query=$query'),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response into a list of ItemModel objects
        List<dynamic> jsonList = json.decode(response.body);
        List<ItemModel> items =
            jsonList.map((json) => ItemModel.fromMap(json)).toList();
        return items;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (error) {
      log('Error searching items: $error');
      return [];
    }
  }

  Future<void> requestToBorrowItem(
    String itemId,
    String borrowerId,
  ) async {
    final url = Uri.parse(
        '${Config.serverURL}items/request'); // Replace with your actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'itemId': itemId,
          'borrowerId': borrowerId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // log('Borrow request submitted: ${responseData['message']}');
        // log('Item: ${responseData['item']}');
        // log('Borrower: ${responseData['borrower']}');
        // log('Proposed Due Date: ${responseData['proposedDueDate']}');
      } else {
        // log('Failed to submit borrow request: ${response.reasonPhrase}');
      }
    } catch (error) {
      // log('Error requesting to borrow item: $error');
    }
  }
}
