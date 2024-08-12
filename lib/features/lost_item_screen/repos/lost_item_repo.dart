import 'dart:convert';
import 'package:finity/core/config/config.dart';
import 'package:finity/models/lost_item_model.dart';
import 'package:http/http.dart' as http;

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

    // Making the API call to create the lost item
    final response = await http.post(
      Uri.parse('${Config.serverURL}/lostItems/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(lostItem.toJson()),
    );

    if (response.statusCode == 201) {
      return LostItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create lost item');
    }
  }

//   // Get a lost item by ID
//   Future<LostItem> getLostItemById(String id) async {
//     final response = await http.get(Uri.parse('$baseUrl/lostItems/$id'));

//     if (response.statusCode == 200) {
//       return LostItem.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load lost item');
//     }
//   }

//   // Get all lost items
//   Future<List<LostItem>> getAllLostItems() async {
//     final response = await http.get(Uri.parse('$baseUrl/lost-items'));

//     if (response.statusCode == 200) {
//       Iterable l = json.decode(response.body);
//       return List<LostItem>.from(l.map((model) => LostItem.fromJson(model)));
//     } else {
//       throw Exception('Failed to load lost items');
//     }
//   }

//   // Update a lost item by ID
//   Future<LostItem> updateLostItem(String id, LostItem lostItem) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/lost-items/$id'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(lostItem.toJson()),
//     );

//     if (response.statusCode == 200) {
//       return LostItem.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to update lost item');
//     }
//   }

//   // Delete a lost item by ID
//   Future<void> deleteLostItem(String id) async {
//     final response = await http.delete(Uri.parse('$baseUrl/lost-items/$id'));

//     if (response.statusCode != 200) {
//       throw Exception('Failed to delete lost item');
//     }
//   }

  // Search for lost items by location
  Future<List<LostItem>> searchLostItemsByLocation({
    required double longitude,
    required double latitude,
    required double maxDistance,
  }) async {
    final response = await http.get(
      Uri.parse(
          '${Config.serverURL}/lostItems/search?longitude=$longitude&latitude=$latitude&maxDistance=$maxDistance'),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<LostItem>.from(l.map((model) => LostItem.fromJson(model)));
    } else {
      throw Exception('Failed to search lost items by location');
    }
  }

  //get near by lost items
  Future<List<LostItem>> getNearByLostItems({
    required double longitude,
    required double latitude,
    required double maxDistance,
  }) async {
    final response = await http.get(
      Uri.parse(
          '${Config.serverURL}/lostItems/nearby?longitude=$longitude&latitude=$latitude&maxDistance=$maxDistance'),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      return List<LostItem>.from(l.map((model) => LostItem.fromJson(model)));
    } else {
      throw Exception('Failed to search lost items by location');
    }
  }
}
