import 'dart:convert';
import 'dart:developer';
import 'package:finity/core/config/config.dart';
import 'package:finity/models/lost_item_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LostItemService {
  // Create a new lost item
  Future<LostItem> createLostItem({
    required String name,
    required String description,
    required String status,
    required DateTime dateLost,
    required String contactInfo,
    required String ownerId,
    required String ownerName,
    required String ownerEmail,
    required String ownerAddress,
    required double latitude,
    required double longitude,
  }) async {
    // Constructing the LostItem model
    LostItem lostItem = LostItem(
      id: '', // ID will be assigned by the database
      name: name,
      description: description,
      status: status,
      dateLost: dateLost,
      contactInfo: contactInfo,
      claims: [],
      owner: Owner(
        id: ownerId,
        name: ownerName,
        email: ownerEmail,
        address: ownerAddress,
      ),
      location: Location(
        type: 'Point',
        coordinates: [longitude, latitude],
      ),
    );
    log(json.encode(lostItem.toJson()));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    final response = await http.post(
      Uri.parse('${Config.serverURL}lostItems/add'),
      headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      body: json.encode(lostItem.toJson()),
    );
    log(response.body);
    if (response.statusCode == 201) {
      return LostItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create lost item');
    }
  }

  // Get a lost item by ID
  Future<LostItem> getLostItemById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    final response = await http.get(
        Uri.parse('${Config.serverURL}/lostItems/$id'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token});

    if (response.statusCode == 200) {
      return LostItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load lost item');
    }
  }

  // // Get all lost items
  // Future<List<LostItem>> getAllLostItems() async {
  //   final response = await http.get(Uri.parse('$baseUrl/lost-items'));

  //   if (response.statusCode == 200) {
  //     Iterable l = json.decode(response.body);
  //     return List<LostItem>.from(l.map((model) => LostItem.fromJson(model)));
  //   } else {
  //     throw Exception('Failed to load lost items');
  //   }
  // }

  // Update a lost item by ID
  Future<LostItem> updateLostItem(String id, LostItem lostItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    final response = await http.put(
      Uri.parse('${Config.serverURL}lostItems/update/$id'),
      headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      body: json.encode(lostItem.toJson()),
    );

    if (response.statusCode == 200) {
      return LostItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update lost item');
    }
  }

  // Delete a lost item by ID
  Future<void> deleteLostItem(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    final response = await http.delete(
        Uri.parse('${Config.serverURL}lostItems/delete/$id'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token});

    if (response.statusCode != 200) {
      throw Exception('Failed to delete lost item');
    }
  }

  // // Search for lost items by location
  // Future<List<LostItem>> searchLostItemsByLocation({
  //   required double longitude,
  //   required double latitude,
  //   required double maxDistance,
  // }) async {
  //   final response = await http.get(
  //     Uri.parse(
  //         '${Config.serverURL}/lostItems/search?longitude=$longitude&latitude=$latitude&maxDistance=$maxDistance'),
  //   );

  //   if (response.statusCode == 200) {
  //     Iterable l = json.decode(response.body);
  //     return List<LostItem>.from(l.map((model) => LostItem.fromJson(model)));
  //   } else {
  //     throw Exception('Failed to search lost items by location');
  //   }
  // }

  //get near by lost items
  Future<List<LostItem>> getNearByLostItems({
    required double longitude,
    required double latitude,
    required double maxDistance,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');

    // Set a default token if not found
    if (token == null) {
      token = '';
      prefs.setString('x-auth-token', token);
    }
    log('token $token');
    // log('${Config.serverURL}lostItems/nearby?longitude=$longitude&latitude=$latitude&maxDistance=$maxDistance');
    final response = await http.get(
      Uri.parse(
          '${Config.serverURL}lostItems/nearby?longitude=$latitude&latitude=$longitude&maxDistance=$maxDistance'),
      headers: {'Content-Type': 'application/json', 'x-auth-token': token},
    );

    log(response.body);
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<LostItem>.from(l.map((model) => LostItem.fromJson(model)));
    } else {
      throw Exception('Failed to search lost items by location');
    }
  }

  // Search for lost items by query
  Future<List<LostItem>> searchLostItems(String searchQuery) async {
    final response = await http.get(
      Uri.parse('${Config.serverURL}lostItems/search?query=$searchQuery'),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<LostItem>.from(l.map((model) => LostItem.fromJson(model)));
    } else {
      throw Exception('Failed to search lost items by query');
    }
  }
}
