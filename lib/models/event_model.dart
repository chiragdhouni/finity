import 'dart:developer';

import 'package:finity/models/address_model.dart'; // Assuming AddressModel is correctly imported

class EventModel {
  String id;
  String title;
  List<String> image;
  String description;
  Owner owner;
  DateTime date;
  AddressModel address; // Changed to AddressModel
  Location location;

  EventModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.owner,
    required this.date,
    required this.address, // Updated type
    required this.location,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    try {
      return EventModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        image: List<String>.from(json['image'] ?? []), // Ensure it's a List
        description: json['description'] ?? '',
        owner: Owner.fromJson(json['owner'] ?? {}), // Ensure non-null
        date: DateTime.parse(json['date'] ??
            DateTime.now().toIso8601String()), // Provide a default date if null
        address: AddressModel.fromMap(
            json['address'] ?? {}), // Ensure it can handle empty
        location: Location.fromJson(json['location'] ?? {}), // Ensure non-null
      );
    } catch (e) {
      log('Error parsing EventModel: $e');
      throw Exception('Failed to parse EventModel');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'image': image,
      'description': description,
      'owner': owner.toJson(),
      'date': date.toIso8601String(),
      'address': address.toMap(), // Convert address to map
      'location': location.toJson(),
    };
  }
}

class Owner {
  String id;
  String name;
  String email;
  AddressModel address; // Changed to AddressModel

  Owner({
    required this.id,
    required this.name,
    required this.email,
    required this.address, // Updated type
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    try {
      return Owner(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        address: AddressModel.fromMap(
            json['address'] ?? {}), // Parse address as AddressModel
      );
    } catch (e) {
      log('Error parsing Owner: $e');
      throw Exception('Failed to parse Owner');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address.toMap(), // Convert address to map
    };
  }
}

class Location {
  String type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point', // Default type if null
      coordinates: List<double>.from(
          json['coordinates']?.map((x) => x.toDouble()) ??
              []), // Ensure it's a List
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
