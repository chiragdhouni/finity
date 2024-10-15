// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:finity/core/config/config.dart';
import 'package:finity/models/address_model.dart';
import 'package:finity/models/item_model.dart';
import 'package:finity/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ItemRepo {
  //add item to lend others
  Future<void> addItem(UserModel user, String itemName, String description,
      String itemCategory, DateTime dueDate) async {
    ItemModel item = ItemModel(
      id: "",
      name: itemName,
      description: description,
      category: itemCategory,
      status: "available",
      owner: Owner(
        id: user.id,
        name: user.name,
        email: user.email,
        address: user.address,
      ),
      dueDate: dueDate,
      location: Location(
        type: "Point",
        coordinates: [],
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    try {
      // Convert the item to a JSON map
      Map<String, dynamic> itemJson = item.toMap();

      // Add the ownerId to the JSON map
      itemJson['ownerId'] = user.id;

      // Encode the JSON map to a JSON string
      String body = jsonEncode(itemJson);

      // log('body is : $body');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      // Set a default token if not found
      if (token == null) {
        token = '';
        prefs.setString('x-auth-token', token);
      }

      http.Response res = await http.post(
        Uri.parse('${Config.serverURL}items/add'),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      // log(res.body);
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
      // log('latitude: $latitude, longitude: $longitude, maxDistance: $maxDistance');
      // log(latitude.runtimeType.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      // Set a default token if not found
      if (token == null) {
        token = '';
        prefs.setString('x-auth-token', token);
      }

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
          'X-Auth-Token': token,
        },
      );

      // log('Response: ${response.body}  ${response.statusCode}');

      if (response.statusCode == 200) {
        List<ItemModel> data = (json.decode(response.body) as List)
            .map((e) => ItemModel.fromMap(e))
            .toList();
        // log('Nearby Items: $data');
        // Handle the data (e.g., update state or use in the UI)
        return data;
      } else {
        throw Exception('Failed to load nearby items');
      }
    } catch (error) {
      // log('Error fetching nearby items: $error');
    }
    return null;
  }

  Future<List<ItemModel>> searchItems(String query) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      // Set a default token if not found
      if (token == null) {
        token = '';
        prefs.setString('x-auth-token', token);
      }

      final response = await http.get(
        Uri.parse(
          '${Config.serverURL}items/search?query=$query',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Auth-Token': token,
        },
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
      // log('Error searching items: $error');
      return [];
    }
  }

  Future<void> requestToBorrowItem(
    String itemId,
    String borrowerId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    // Set a default token if not found
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }

    final url = Uri.parse(
        '${Config.serverURL}items/request'); // Replace with your actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'X-Auth-Token': token},
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

  Future<List<ItemModel>> getItemByIds(List<String> itemIds) async {
    // Fetch token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');

    // Set a default token if not found
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }

    // Define the API endpoint URL
    final url = Uri.parse('${Config.serverURL}items/getItemByIds');

    try {
      // Make the POST request to the API with itemIds
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Auth-Token': token,
        },
        body: jsonEncode({
          'itemIds': itemIds, // Sending the itemIds in the request body
        }),
      );

      // Check if the response is successful (status code 200)
      if (response.statusCode != 200) {
        throw Exception('Failed to get items by ids: ${response.body}');
      }

      // Parse the response body as JSON
      final List<dynamic> responseData = jsonDecode(response.body);

      // Map the JSON data to a list of ItemModel objects
      List<ItemModel> items =
          responseData.map((json) => ItemModel.fromMap(json)).toList();

      // Return the list of items
      return items;
    } catch (error) {
      // Log the error and throw it for further handling
      log('Error getting items by ids: $error');
      throw error; // Ensure the function always returns or throws
    }
  }
}
